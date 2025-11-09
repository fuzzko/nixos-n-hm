use komo/pango.nu *

def main [section: string]: nothing -> string {
  let time = date now

  match $section {
    "hourminute" => {
      let text = $time | format date "%H\n%M"
      span weight heavy
      | span lineHeight .6
      | span $text
    }
    "date" => {
      let text = $time | format date "%A, %B %d\n%Y"
      span weight bold
      | span $text
    }
  }
}
