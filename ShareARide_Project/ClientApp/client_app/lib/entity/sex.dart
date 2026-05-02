enum Sex {
  Male,
  Female, 
}

extension SexLabel on Sex {
  String get label {
    switch (this) {
      case Sex.Male:
        return "Мъж";
      case Sex.Female:
        return "Жена";
    }
  }
}