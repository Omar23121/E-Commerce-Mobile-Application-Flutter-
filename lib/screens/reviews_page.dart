import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../models/review.dart';
import '../providers/app_state.dart';

class ReviewsPage extends StatefulWidget {
  final Product product;
  const ReviewsPage(this.product, {super.key});

  @override
  State<ReviewsPage> createState() => _ReviewsPageState();
}

class _ReviewsPageState extends State<ReviewsPage> {
  int rating = 5;
  final commentCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final app = Provider.of<AppState>(context);
    final list = app.reviews[widget.product.name] ?? [];

    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.product.name} Reviews"),
      ),
      body: Column(
        children: [
          Expanded(
            child: list.isEmpty
                ? const Center(child: Text("No reviews yet."))
                : ListView.builder(
              itemCount: list.length,
              itemBuilder: (_, i) {
                final r = list[i];
                return ListTile(
                  leading: CircleAvatar(
                    child: Text(
                      r.username.isNotEmpty
                          ? r.username[0].toUpperCase()
                          : 'G',
                    ),
                  ),
                  title: Text(
                      "${r.username} • ⭐${r.rating}"),
                  subtitle: Text(r.comment),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.grey.shade100,
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                const Text(
                  "Add a Review",
                  style: TextStyle(
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                DropdownButton<int>(
                  value: rating,
                  items: [1, 2, 3, 4, 5]
                      .map((e) =>
                      DropdownMenuItem(
                        value: e,
                        child: Text("$e Stars"),
                      ))
                      .toList(),
                  onChanged: (v) =>
                      setState(() => rating = v!),
                ),
                TextField(
                  controller: commentCtrl,
                  decoration:
                  const InputDecoration(
                      labelText: "Comment"),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () {
                    final comment =
                    commentCtrl.text.trim();
                    if (comment.isEmpty) return;

                    final review = Review(
                      app.user?.username ??
                          "Guest",
                      rating,
                      comment,
                    );

                    app.addReview(
                        widget.product.name,
                        review);

                    commentCtrl.clear();
                  },
                  child:
                  const Text("Submit Review"),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}