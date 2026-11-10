sealed class RepositoryException implements Exception {
  const RepositoryException(this.message);
  final String message;
  @override
  String toString() => '$runtimeType: $message';
}

final class AmendmentReasonRequiredException extends RepositoryException {
  const AmendmentReasonRequiredException(String entryId)
    : super('amendmentReason is required to amend entry $entryId');
}

final class EntityNotFoundException extends RepositoryException {
  const EntityNotFoundException(String type, String id)
    : super('$type $id not found');
}

final class InvalidStatusTransitionException extends RepositoryException {
  const InvalidStatusTransitionException(String id, String from, String to)
    : super('investigation $id cannot move $from -> $to');
}
