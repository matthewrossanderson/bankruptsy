builder do |x|

    x.feed(xmlns: "http://www.w3.org/2005/Atom") {

      x.title     "Title"
      x.updated   to_xs_date_time Time.now.utc
      x.link      href: url("/"), rel: "self"
      x.id        ""

      @cases.each do |post|
        x.entry {
          x.title     "Title"
          x.link      "URL"
          x.id       "ID"
          x.content   "Content", type: 'html'
          x.updated   to_xs_date_time Time.now.utc
          x.author    { "Author" }
        }
      end
    }
  end