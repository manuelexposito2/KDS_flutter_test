import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:kds/models/status/detail_dto.dart';
import 'package:kds/repository/repository/status_detail_repository.dart';

part 'status_detail_event.dart';
part 'status_detail_state.dart';

class StatusDetailBloc extends Bloc<StatusDetailEvent, StatusDetailState> {
  final StatusDetailRepository statusDetailRepository;


  StatusDetailBloc(this.statusDetailRepository) : super(StatusDetailInitial()) {
    on<DoStatusDetailEvent>(_doDetailEvent);
  }

  void _doDetailEvent(DoStatusDetailEvent event, Emitter<StatusDetailState> emit)async {
    emit(StatusDetailLoadingState());
    try{
      final statusDetailResponse = await statusDetailRepository.statusDetail(event.detailDto);
      emit(StatusDetailSuccessState());
      return;
    }on Exception catch (e){
      emit(StatusDetailErrorState(e.toString()));
    }
  }
}
