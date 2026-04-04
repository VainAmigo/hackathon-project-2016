/// Одноразовое уведомление для snackbar; сбрасывается через [AuthSessionCubit.clearNotice].
enum AuthSessionNotice {
  none,
  loginSuccess,
  logoutSuccess,
  refreshFailedOnStartup,
  sessionExpiredRefresh,
}
