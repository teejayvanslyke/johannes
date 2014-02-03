require 'imgkit'
require 'mini_magick'
require 'enigma'

module Johannes

  class Base
    def initialize(attributes={})
      @text  = attributes['text'] || ''
      @width = attributes['width'] || nil
      @size  = attributes['size'] || '12px'
      @font  = attributes['font'] || 'Helvetica Neue'
      @align = attributes['align'] || 'left'
      @color = attributes['color'] || 'black'
      @line_height = attributes['line_height'] || '1.0em'
    end

    @stylesheets = []

    def self.stylesheets
      @stylesheets
    end

    def self.stylesheets=(val)
      @stylesheets = val
    end


    attr_reader :text, :width, :font

    def css_attributes
      {
        'display'     => 'inline',
        'font-family' => @font,
        'text-align'  => @align,
        'font-size'   => @size,
        'color'       => @color,
        'line-height' => @line_height,
        'width'       => @width || 'auto'
      }
    end

    def css
      rval = ''
      css_attributes.each do |key, value|
        rval << "#{key}: #{value};"
      end

      rval
    end

    def stylesheet_link_tags
      Johannes::Base.stylesheets.map do |url|
        %{<link rel="stylesheet" type="text/css" href="#{url}"/>}
      end.join('')
    end

    def to_html
      %{
        <html>
          <head>
            #{stylesheet_link_tags}
          </head>
          <body>
            <div style="#{css}">#{text}</div>

            <script type="text/javascript">
            </script>
          </body>
        </html>
      }
    end

    def to_image
      image = MiniMagick::Image.read(IMGKit.new(to_html, width: @width).to_img)
      image.trim
      image.to_blob
    end
  end

end

