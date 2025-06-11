class UploadImageResult {
  final UploadImageResultStates state;
  final String response;

  UploadImageResult(this.state, this.response);
}

enum UploadImageResultStates { isLoading, isError, isData, isIdle }

class UpdateProfileResult {
  final UpdateProfileResultStates state;
  final String response;

  UpdateProfileResult(this.state, this.response);
}

enum UpdateProfileResultStates { isLoading, isError, isData, isIdle }