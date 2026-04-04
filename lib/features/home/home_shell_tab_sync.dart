/// Связь с [HomePage], когда поверх открыт отдельный [Navigator]-маршрут
/// (наследники [ModalRoute] не видят `InheritedWidget` внутри body домашнего экрана).
class HomeShellTabSync {
  void Function(int tabIndex)? _setTab;

  void bind(void Function(int tabIndex) setTab) => _setTab = setTab;

  void unbind() => _setTab = null;

  void selectTab(int index) => _setTab?.call(index);
}
