abstract class BaseState<S, P> {
  final S data;
  final P eventState;

  BaseState(this.data, this.eventState);

  @override
  String toString() {
    return eventState.runtimeType.toString();
  }
}