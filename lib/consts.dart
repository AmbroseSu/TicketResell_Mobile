final RegExp EMAIL_VALIDATION_REGEX =
    RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");
final RegExp PASSWORD_VALIDATION_REGEX =
    RegExp(r"^(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[a-zA-z]).{8,}$");
final RegExp NAME_VALIDATION_REGEX = RegExp(r"\b([A-Z][-,a-z. ']+[ ]*)+");
final String PLACEHOLDER_PFF = "https://cdn.pixabay.com/photo/2023/02/18/11/00/icon-7797704_1280.png";