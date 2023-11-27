import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:media_app/models/video_model/video_model.dart';
import 'package:media_app/shared/constants/constants.dart';
import 'package:media_app/shared/network/remote/dio_helper/dio_helper.dart';
import 'package:media_app/shared/network/remote/end_points/end_points.dart';
import 'package:meta/meta.dart';

import '../../../models/image_model/image_model.dart';

part 'app_state.dart';

class AppCubit extends Cubit<AppState> {
  AppCubit() : super(AppInitial());
  static AppCubit get(context)=>BlocProvider.of(context);

  List<ImageModel> images = [];
  List<VideoModel> videos = [];

  void getImages({
  required String text,
}){
    images = [];
    emit(GetImagesLoading());
    DioHelper.getData(
        url: PHOTO_SEARCH,
      token: API_KEY,
      query: {
          'query':text,
      }
    ).then((value) {
      if(value.statusCode == 200){
        value.data['photos'].forEach((element){
          images.add(ImageModel.fromJson(element));
        });
        emit(GetImagesSuccessfully());
      }
      else{
        if (kDebugMode) {
          print(value.data);
        }
        emit(GetImagesError());
      }
    }).catchError((error){
      if(kDebugMode){
        print(error.toString());
      }
      emit(GetImagesError());
    });

  }

  void getVideos({
  required String text,
}){
    videos = [];
    emit(GetVideosLoading());
    DioHelper.getData(
        url: VIDEO_SEARCH,
        token: API_KEY,
        query: {
          'query':text,
        }
    ).then((value) {
      if(value.statusCode == 200){
        value.data['videos'].forEach((element){
          videos.add(VideoModel.fromJson(element));
        });
        emit(GetVideosSuccessfully());
      }
      else{
        if (kDebugMode) {
          print(value.data);
        }
        emit(GetVideosError());
      }
    }).catchError((error){
      if(kDebugMode){
        print(error.toString());
      }
      emit(GetVideosError());
    });

  }
}
