class Message {
  final String role;
  final String content;
  final Assistant assistant;
  final bool? isErrored;

  Message({
    required this.role,
    required this.content,
    required this.assistant,
    this.isErrored,
  });

  Map<String, dynamic> toJson() => {
        'role': role,
        'content': content,
        'assistant': assistant.toJson(),
        if (isErrored != null) 'isErrored': isErrored,
      };

  factory Message.fromJson(Map<String, dynamic> json) => Message(
        role: json['role'],
        content: json['content'],
        assistant: Assistant.fromJson(json['assistant']),
        isErrored: json['isErrored'],
      );
}

class Assistant {
  final String id;
  final String model;
  final String name;

  Assistant({
    required this.id,
    required this.model,
    required this.name,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'model': model,
        'name': name,
      };

  factory Assistant.fromJson(Map<String, dynamic> json) => Assistant(
        id: json['id'],
        model: json['model'],
        name: json['name'],
      );
}

class ChatResponse {
  final String conversationId;
  final String message;
  final int remainingUsage;

  ChatResponse({
    required this.conversationId,
    required this.message,
    required this.remainingUsage,
  });

  factory ChatResponse.fromJson(Map<String, dynamic> json) => ChatResponse(
        conversationId: json['conversationId'],
        message: json['message'],
        remainingUsage: json['remainingUsage'],
      );
}

class ChatException implements Exception {
  final String message;
  final int statusCode;

  ChatException({required this.message, required this.statusCode});
}
