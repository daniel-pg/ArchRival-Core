#let bitfield-table(
  // Array of field definitions: `(name, bits, [bg-color], [text-color])`
  fields,
  // List of lists, where each inner list contains values for the fields
  encodings: (),
  // --- Visual Configuration Parameters ---
  header-height: 1.0em,  // Height of the bit-number row
  row-height: 2.5em,     // Height of the field-name row
  tick-height: 3pt,      // Length of the small vertical ticks
  header-size: 1.0em,    // Font size for the bit numbers
  stroke-width: 0.5pt,   // Thickness of borders and ticks
  row-gutter: 5pt        // Vertical space between bit numbers and the box
) = {

  // 1. Process fields to calculate start/end indices and colors
  let processed = ()
  let current-bit = 0

  for item in fields {
    let name = item.at(0)
    let bits = item.at(1)

    // Optional 3rd arg: Background Color (default: none)
    let bg-color = if item.len() > 2 { item.at(2) } else { none }

    // Optional 4th arg: Text Color (default: black)
    let text-color = if item.len() > 3 { item.at(3) } else { black }

    processed.push((
      name: name,
      bits: bits,
      bg-color: bg-color,
      text-color: text-color,
      start: current-bit,
      end: current-bit + bits - 1
    ))
    current-bit += bits
  }

  // Reverse fields for display (MSB -> LSB)
  let items = processed.rev()

  // 2. Prepare Encodings
  // The table is rendered reversed (MSB first), but users usually
  // provide data in logical order. We reverse every encoding row
  // to match the visual column order.
  let aligned-encodings = encodings.map(row => row.rev())

  // 3. Render
  table(
    columns: items.map(i => i.bits * 1fr),
    // Row 0: Header, Row 1: Box, Row 2+: Encodings (auto height)
    rows: (header-height, row-height) + (auto,) * encodings.len(),

    // Only stroke the Box row (Index 1)
    stroke: (x, y) => if y == 1 { stroke-width } else { none },

    column-gutter: 0pt,
    row-gutter: row-gutter,
    inset: 0pt,

    // --- Row 0: Bit Numbers ---
    ..items.map(i => {
      layout(size => {
        let w = size.width
        let bit-width = w / i.bits

        set text(size: header-size)

        block(width: 100%, height: 100%, {
          if i.bits == 1 {
             align(center + bottom, str(i.start))
          } else {
             place(left + bottom, block(width: bit-width, align(center, str(i.end))))
             place(right + bottom, block(width: bit-width, align(center, str(i.start))))
          }
        })
      })
    }),

    // --- Row 1: Field Names (The Box) ---
    ..items.map(i => {
      layout(size => {
        let w = size.width
        let bit-width = w / i.bits

        // Generate ticks
        let ticks = ()
        if i.bits > 1 {
          ticks = range(1, i.bits).map(b => {
            let dx = b * bit-width
            place(top + left, dx: dx, line(length: tick-height, angle: 90deg, stroke: stroke-width))
            place(bottom + left, dx: dx, line(length: tick-height, angle: -90deg, stroke: stroke-width))
          })
        }

        // Render block with background color
        block(width: 100%, height: 100%, fill: i.bg-color, {
          ticks.join()
          align(center + horizon, text(fill: i.text-color)[#i.name])
        })
      })
    }),

    // --- Row 2+: Instruction Encodings ---
    // Flatten the array so table accepts them as individual cells
    ..aligned-encodings.flatten().map(val => {
       align(center + top, val)
    })
  )
}
