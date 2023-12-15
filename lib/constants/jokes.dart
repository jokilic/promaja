import 'dart:math';

class PromajaJokes {
  static const weatherJokes = [
    'Why did the cloud break up with the thunderstorm? Because it was too controlling and always raining on its parade!',
    "What did one raindrop say to the other? 'Two's company, three's a cloud!'",
    'Why did the weather report go to school? To improve its climate!',
    "How does a meteorologist organize a party? They just 'low pressure' everyone to attend!",
    "What's a snowman's favorite breakfast? Frosted flakes!",
    'Why did the sun go to school? To get a little brighter!',
    'What do you call dangerous precipitation? A rain of terror!',
    "How does a weather reporter greet you? 'Hail there!'",
    'Why did the weather forecaster bring a bar of soap to work? They were expecting showers!',
    "What did one tornado say to the other tornado? 'Let's twist again, like we did last summer!'",
    'Why did the cloud get in trouble at school? It was always getting too misty-eyed during emotional math problems!',
    'How does a lightning bolt get good grades? It strikes for success!',
    "What's a weather balloon's favorite type of music? Anything with heavy atmosphere!",
    'Why was the weather map cold? Because it had a front and a cold shoulder!',
    "What did the hurricane say to the coconut tree? 'Hang onto your nuts, this ain't no ordinary breeze!'"
  ];

  static String getRandomJoke() {
    final random = Random();
    final index = random.nextInt(weatherJokes.length);
    return weatherJokes[index];
  }
}
