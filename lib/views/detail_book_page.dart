import 'package:book_app/controllers/book_controller.dart';
import 'package:book_app/views/image_view_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailBookPage extends StatefulWidget {
  const DetailBookPage({super.key, required this.isbn});
  final String isbn;

  @override
  State<DetailBookPage> createState() => _DetailBookPageState();
}

class _DetailBookPageState extends State<DetailBookPage> {
  BookController? controller;
  @override
  void initState() {
    super.initState();
    controller = Provider.of<BookController>(context, listen: false);
    controller!.fetchDetailBookApi(widget.isbn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail'),
      ),
      body: Consumer<BookController>(builder: (context, controller, chil) {
        return controller.detailBook == null
            ? const Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ImageViewScreen(
                                    imageUrl: controller.detailBook!.image!),
                              ),
                            );
                          },
                          child: Image.network(
                            controller.detailBook!.image!,
                            height: 200,
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  controller.detailBook!.title!,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  controller.detailBook!.authors!,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: List.generate(
                                    5,
                                    (index) => Icon(
                                      Icons.star,
                                      color: index <
                                              int.parse(controller
                                                  .detailBook!.rating!)
                                          ? Colors.yellow
                                          : Colors.grey,
                                    ),
                                  ),
                                ),
                                Text(
                                  controller.detailBook!.subtitle!,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  controller.detailBook!.price!,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(),
                        onPressed: () async {
                          Uri uri = Uri.parse(controller.detailBook!.url!);
                          try {
                            (await canLaunchUrl(uri))
                                ? launchUrl(uri)
                                : debugPrint("Tidak berhasil navigasi");
                          } catch (e) {
                            debugPrint("error");
                          }
                        },
                        child: const Text("BUY"),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(controller.detailBook!.desc!),
                    const SizedBox(
                      height: 20,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text("Year: " + controller.detailBook!.year!),
                        Text("ISBN " + controller.detailBook!.isbn13!),
                        Text(controller.detailBook!.pages! + " Page"),
                        Text("Publisher: " + controller.detailBook!.publisher!),
                        Text("Language: " + controller.detailBook!.language!),
                      ],
                    ),
                    const Divider(),
                    controller.similiarBooks == null
                        ? const CircularProgressIndicator()
                        : SizedBox(
                            height: 180,
                            child: ListView.builder(
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemCount:
                                  controller.similiarBooks!.books!.length,
                              itemBuilder: (context, index) {
                                final current =
                                    controller.similiarBooks!.books![index];
                                return SizedBox(
                                  width: 100,
                                  child: Column(
                                    children: [
                                      Image.network(
                                        current.image!,
                                        height: 100,
                                      ),
                                      Text(
                                        current.title!,
                                        maxLines: 3,
                                        textAlign: TextAlign.center,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          )
                  ],
                ),
              );
      }),
    );
  }
}
