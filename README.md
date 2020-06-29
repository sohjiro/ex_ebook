# ExEbook

Metadata extracter for digital books (EPUB, MOBI, PDF)

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `ex_ebook` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:ex_ebook, "~> 0.1.0"}
  ]
end
```

## Dependencies

At this moment ex_ebook needs [libmobi](https://github.com/bfabiszewski/libmobi/) and [xpdfreader](https://www.xpdfreader.com/index.html) in order to extract metadata from PDF and MOBI files.


## Usage

Extract everything in one step just as follows:

**EPUB**
```elixir
iex> "~/Downloads/programming-ecto_p1_0.epub" |> Path.expand |> ExEbook.extract_metadata
%ExEbook.Metadata{
  authors: ["Darin Wilson", "Eric Meadows-Jönsson"],
  isbn: "978-1-68050-282-4",
  language: "en",
  pages: nil,
  publisher: "The Pragmatic Bookshelf, LLC (711823)",
  subject: "Pragmatic Bookshelf",
  title: "Programming Ecto (for Felipe Juarez Murillo)"
}
```

**PDF**
```elixir
iex> "~/Downloads/programming-ecto_p1_0.pdf" |> Path.expand() |> ExEbook.extract_metadata
%ExEbook.Metadata{
  authors: ["Darin Wilson", "Eric Meadows-Jönsson"],
  isbn: nil,
  language: nil,
  pages: "231",
  publisher: "Pragmatic Bookshelf",
  subject: nil,
  title: "Programming Ecto"
}
```

**MOBI**
```elixir
iex> "~/Downloads/programming-ecto_p1_0.mobi" |> Path.expand() |> ExEbook.extract_metadata
%ExEbook.Metadata{
  authors: ["Darin Wilson", "Eric Meadows-Jönsson"],
  isbn: nil,
  language: "en (utf8)",
  pages: nil,
  publisher: "The Pragmatic Bookshelf, LLC",
  subject: "Pragmatic Bookshelf",
  title: "Programming Ecto"
}
```

And that's all


## TO DO's

* [ ] Using internal tool for reading MOBI metadata

* [ ] Support for different files in EPUB

  At this moment we only support `content.opf` as the main file for extracting metadata. We need to change it and scan the `META-INF` directory and look for the `container` tag (probably inside `META-INF/container.xml`)

* [ ] Using internal tool for reading PDF metadata

* [ ] Improve Docs
