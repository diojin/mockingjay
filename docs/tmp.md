b += (1, 2, 3, 5)
// ArrayBuffer(1, 1, 2, 3, 5)
// Add multiple elements at the end by enclosing them in parentheses
b ++= Array(8, 13, 21)
// ArrayBuffer(1, 1, 2, 3, 5, 8, 13, 21)
// You can append any collection with the ++= operator
b.trimEnd(5)
// ArrayBuffer(1, 1, 2)
// Removes the last five elements

Sometimes, you want to build up an Array, but you don’t yet know how many elements you will need. In that case, first make an
array buffer, then call
b.toArray
// Array(1, 1, 2)
Conversely, call a.toBuffer to convert the array a to an array buffer.

It is very easy to take an array (or array buffer) and transform it in some way. Such transformations don’t modify the original array, but they yield a new one.

Oftentimes, when you traverse a collection, you only want to process the elements that match a particular condition. This is
achieved with a guard: an if inside the for. Here we double every even element, dropping the odd ones:
for (elem <- a if elem % 2 == 0) yield 2 * elem
Alternatively, you could write
a.filter(_ % 2 == 0).map(2 * _)
or even
Click here to view code image
a filter { _ % 2 == 0 } map { 2 * _ }
Some programmers with experience in functional programming prefer filter and map to guards and yield. That’s just a
matter of style—the for loop does exactly the same work. Use whichever you find easier.
Keep in mind that the result is a new collection—the original collection is not affected.

var first = false
val indexes = for (i <- 0 until a.length if first || a(i) >= 0) yield {
	if (a(i) < 0) first = false; i
}

val b = ArrayBuffer(1, 7, 2, 9)
val bDescending = b.sortWith(_ > _) // ArrayBuffer(9, 7, 2, 1)

You can sort an array, but not an array buffer, in place:
val a = Array(1, 7, 2, 9)
scala.util.Sorting.quickSort(a)
// a is now Array(1, 2, 7, 9)
For the min, max, and quickSort methods, the element type must have a comparison operation. This is the case for numbers
strings, and other types with the Ordered trait.
