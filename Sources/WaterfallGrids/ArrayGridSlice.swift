/// A slice of an `Array` that represents a column (or a row) in a 2D grid.
///
/// The `ArrayGridSlice` type is a view into a 2D grid of elements stored in a flat `Array`. It provides a way to access a single column (or row) of the grid as if it were a separate `Array`.
///
/// ```swift
/// let array = [0, 1, 2, 3, 4, 5, 6, 7]
/// let slice1 = array.columnSlice(column: 0, totalColumns: 2)
/// let slice2 = array.columnSlice(column: 1, totalColumns: 2)
/// print(slice1 == slice2) // false
/// print(slice1) // [0, 2, 4, 6]
/// print(slice2) // [1, 3, 5, 7]
/// ```
///
/// > `ArrayGridSlice` is a view into `Array`, such as `ArraySlice`, meaning that there is no performance cost for creating a slice of an `Array`.
public struct ArrayGridSlice<Source: RandomAccessCollection>: RandomAccessCollection where Source.Index == Int {
  let source: Source
  
  /// The column index of the slice.
  public let column: Int
  
  /// The total number of columns in the grid.
  public let totalColumns: Int
  
  public var startIndex: Int { source.startIndex }
  
  public var endIndex: Int { (source.count / totalColumns + (source.count % totalColumns > column ? 1 : 0)) + source.startIndex }
  
  public subscript(index: Int) -> Source.Element {
    get {
      let flatIndex = ((index - startIndex) * totalColumns + column) + startIndex
      return source[flatIndex]
    }
  }
}

extension ArrayGridSlice: CustomStringConvertible {
  public var description: String {
    var result = "["
    for (index, element) in enumerated() {
      result += "\(element)"
      if index < count - 1 {
        result += ", "
      }
    }
    result += "]"
    return result
  }
}

extension ArrayGridSlice: Equatable where Source.Element: Equatable {
  public static func == (lhs: ArrayGridSlice<Source>, rhs: ArrayGridSlice<Source>) -> Bool {
    lhs.count == rhs.count &&
    zip(lhs, rhs).allSatisfy { $0 == $1 }
  }
}

extension ArrayGridSlice: Hashable where Source.Element: Hashable {
  public func hash(into hasher: inout Hasher) {
    for element in self {
      hasher.combine(element)
    }
  }
}

extension ArrayGridSlice: Sendable where Source: Sendable {}

extension RandomAccessCollection where Index == Int {
  
  /// Returns a slice of the collection that represents a column in a 2D grid.
  ///
  /// This method returns a view into the collection that represents a single column in a 2D grid.
  /// - Parameters:
  ///   - column: The index of the column to slice.
  ///   - totalColumns: The total number of columns in the grid.
  /// - Returns: A view into the collection that represents a single column in a 2D grid.
  public func columnSlice(column: Int, totalColumns: Int) -> ArrayGridSlice<Self> {
    ArrayGridSlice(source: self, column: column, totalColumns: totalColumns)
  }
}
