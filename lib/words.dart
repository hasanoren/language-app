class Words {
  Map<String, String> fruits = {
    "apple": "elma",
    "grape": "üzüm",
    "cherry": "kiraz",
    "orange": "portakal",
    "banana": "muz",
    "melon": "kavun",
    "coconut": "hindistan cevizi",
    "plum": "erik",
    "peanut": "fıstık",
    "walnut": "ceviz",
    "hazelnut": "fındık",
    "tangerine": "mandalina",
    "strawberry": "çilek",
    "kiwi": "kivi",
    "pear": "armut",
  };

  //Kelime Map'ini karıştırıp return eder.
  Map<String, String> shuffleMap() {
    List<MapEntry<String, String>> entries = fruits.entries.toList();
    entries.shuffle();
    Map<String, String> shuffledMap = Map.fromEntries(entries);
    return shuffledMap;
  }
}
