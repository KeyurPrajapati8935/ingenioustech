import 'dart:async';
import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:ingenioustechlab/base/apis/api_url.dart';
import 'package:ingenioustechlab/models/airports_model.dart';
import 'package:ingenioustechlab/models/model.dart';
import 'package:stream_transform/stream_transform.dart';

part 'post_event.dart';

part 'post_state.dart';

const _postLimit = 20;
const throttleDuration = Duration(milliseconds: 100);

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

class PostBloc extends Bloc<PostEvent, PostState> {
  PostBloc({required this.httpClient}) : super(const PostState()) {
    on<PostFetched>(
      _onPostFetched,
      transformer: throttleDroppable(throttleDuration),
    );
  }

  final http.Client httpClient;

  Future<void> _onPostFetched(
    PostFetched event,
    Emitter<PostState> emit,
  ) async {
    if (state.hasReachedMax) return;
    try {
      if (state.status == PostStatus.initial) {
        // Check offline data is available or not
        var posts = await Hive.openBox<Airport>('airports');
        if(posts.values.toList().isNotEmpty) {
          posts = await Hive.openBox<Airport>('airports');
        }else{
          posts = (await _fetchAirportList()) as Box<Airport>;
        }

        return emit(state.copyWith(
          status: PostStatus.success,
          posts: posts.values.toList(),
          hasReachedMax: false,
        ));
      }

      // Check offline data is available or not
      var posts = await Hive.openBox<Airport>('airports');
      if(posts.values.toList().length > 0) {
        posts = await Hive.openBox<Airport>('airports');
      }else{
        posts = (await _fetchAirportList(state.posts.length)) as Box<Airport>;
      }
      posts.isEmpty
          ? emit(state.copyWith(hasReachedMax: true))
          : emit(
              state.copyWith(
                status: PostStatus.success,
                posts: List.of(state.posts)..addAll(posts.values),
                hasReachedMax: false,
              ),
            );
    } catch (_) {
      emit(state.copyWith(status: PostStatus.failure));
    }
  }

  Future<List<Airport>> _fetchAirportList([int startIndex = 0]) async {
    final response = await httpClient.get(
      Uri.https(
        ApiUrls.kBaseUrl,
        ApiUrls.kAirportUrl,
        <String, String>{'_start': '$startIndex', '_limit': '$_postLimit'},
      ),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> decoded = json.decode(response.body);
      List<Airport> airpotList = [];
      for (var colour in decoded.keys) {
        try {
          airpotList.add(Airport(
              icao: decoded[colour]['icao'],
              name: decoded[colour]['name'],
              city: decoded[colour]['city'],
              state: decoded[colour]['state'],
              country: decoded[colour]['country'],
              lat: decoded[colour]['lat'],
              lon: decoded[colour]['lon'],
              tz: decoded[colour]['tz']));

          Airport airport = Airport(
              icao: decoded[colour]['icao'],
              name: decoded[colour]['name'],
              city: decoded[colour]['city'],
              state: decoded[colour]['state'],
              country: decoded[colour]['country'],
              lat: decoded[colour]['lat'],
              lon: decoded[colour]['lon'],
              tz: decoded[colour]['tz']);

          var box = await Hive.openBox<Airport>('airports');
          box.add(airport);
          print('$box');
        } catch (e) {
          // ignore: avoid_print
          print('EXCEPTION IS ===> $e');
        }
      }
      return airpotList;
    }
    throw Exception('error fetching airportList');
  }
}
