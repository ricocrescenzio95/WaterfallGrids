import SwiftUI

/// A type that represents the axis of a ``WaterfallGrid`` or ``LazyWaterfallGrid``.
///
/// You can use this type to specify the layout of the grid, either by columns or rows when creating a grid;
/// the grid will grow in the specified axis and will use the array of ``WaterfallItems/Row`` or ``WaterfallItems/Column`` you passed to build n rows or columns.
public enum WaterfallItems: Sendable, Equatable {
  
  /// A grid that grows in the vertical axis.
  case columns([Column])
  
  /// A grid that grows in the horizontal axis.
  case rows([Row])

  /// Sets the spacing between elements in all columns or rows.
  /// - Parameter spacing: The spacing to set.
  public mutating func setAllSpacings(_ spacing: CGFloat) {
    switch self {
    case .columns(let columns):
      self = .columns(
        columns.map { Column(alignment: $0.alignment, spacing: spacing) }
      )
    case .rows(let rows):
      self = .rows(
        rows.map { Row(alignment: $0.alignment, spacing: spacing) }
      )
    }
  }
  
  /// Sets the spacing between elements in a specific column or row.
  /// - Parameters:
  ///   - spacing: The spacing to set.
  ///   - index: The index of the column or row.
  public mutating func setSpacing(_ spacing: CGFloat, at index: Int) {
    switch self {
    case .columns(let columns):
      var columns = columns
      columns[index].spacing = spacing
      self = .columns(columns)
    case .rows(let rows):
      var rows = rows
      rows[index].spacing = spacing
      self = .rows(rows)
    }
  }
  
  /// Sets the spacing between elements in all columns or rows, returning a new instance.
  /// - Parameter spacing: The spacing to set.
  /// - Returns: A new instance of ``WaterfallItems`` with the specified spacing.
  public func settingAllSpacings(_ spacing: CGFloat) -> Self {
    var copy = self
    copy.setAllSpacings(spacing)
    return copy
  }
  
  /// Sets the spacing between elements in a specific column or row, returning a new instance.
  /// - Parameters:
  ///  - spacing: The spacing to set.
  ///  - index: The index of the column or row.
  ///  - Returns: A new instance of ``WaterfallItems`` with the specified spacing.
  public func settingSpacing(_ spacing: CGFloat, at index: Int) -> Self {
    var copy = self
    copy.setSpacing(spacing, at: index)
    return copy
  }
  
  /// The total number of columns or rows in the grid.
  public var itemsCount: Int {
    switch self {
    case .columns(let columns): columns.count
    case .rows(let rows): rows.count
    }
  }
  
  /// Returns all ``WaterfallItems/Column`` if the grid grows in the vertical axis, otherwise `nil`.
  public var columns: [Column]? {
    switch self {
    case .columns(let columns): columns
    case .rows: nil
    }
  }
  
  /// Returns all ``WaterfallItems/Row`` if the grid grows in the horizontal axis, otherwise `nil`.
  public var rows: [Row]? {
    switch self {
    case .columns: nil
    case .rows(let rows): rows
    }
  }
  
  /// Returns true if the grid grows in the vertical axis, otherwise false.
  public var isVertical: Bool {
    switch self {
    case .columns: true
    case .rows: false
    }
  }
  
  /// Returns true if the grid grows in the horizontal axis, otherwise false.
  public var isHorizontal: Bool {
    switch self {
    case .columns: false
    case .rows: true
    }
  }
}

extension WaterfallItems {
  /// Tells the grid how a single column will lay out each child.
  public struct Column: Sendable, Equatable {
    
    /// The horizontal alignment of each child in the column.
    public var alignment: HorizontalAlignment
    
    /// The spacing between children.
    public var spacing: CGFloat?
    
    /// Creates a new instance of ``WaterfallItems/Column``.
    /// - Parameters:
    ///   - alignment: The horizontal alignment of each child in the column.
    ///   - spacing: The spacing between children.
    public init(
      alignment: HorizontalAlignment = .center,
      spacing: CGFloat? = nil
    ) {
      self.alignment = alignment
      self.spacing = spacing
    }
  }
  
  /// Tells the grid how a single row will lay out each child
  public struct Row: Sendable, Equatable {
    
    /// The vertical alignment of each child in the row.
    public var alignment: VerticalAlignment
    
    /// The spacing between children.
    public var spacing: CGFloat?
    
    /// Creates a new instance of ``WaterfallItems/Row``.
    /// - Parameters:
    ///  - alignment: The vertical alignment of each child in the row.
    ///  - spacing: The spacing between children.
    public init(
      alignment: VerticalAlignment = .center,
      spacing: CGFloat? = nil
    ) {
      self.alignment = alignment
      self.spacing = spacing
    }
  }
}
