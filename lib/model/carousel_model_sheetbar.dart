class CarouselModel {
  String? image;

  CarouselModel(this.image);
}

List<CarouselModel?> carousels =
    carouselListData.map((item) => CarouselModel(item['image'])).toList();

var carouselListData = [
  {"image": "assets/intro_page/intro_1.png"},
  {"image": "assets/intro_page/intro_2.png"},
  {"image": "assets/intro_page/intro_3.png"},
  {"image": "assets/intro_page/intro_4.png"}
];
