require 'imgkit'
require 'mini_magick'

module Johannes

  class Base
    def initialize(attributes={})
      @text  = attributes['text'] || ''
      @width = attributes['width'] || nil
      @size  = attributes['size'] || '12px'
      @font  = attributes['font'] || 'Helvetica Neue'
      @line_height = attributes['line_height'] || '1.0em'
    end

    attr_reader :text, :width, :font

    def css_attributes
      {
        'display'     => 'inline',
        'font-family' => @font,
        'font-size'   => @size,
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

    def to_html
      %{
        <html>
          <head></head>
          <body>
            <div style="#{css}">#{text}</div>

            <script type="text/javascript">
            </script>
          </body>
        </html>
      }
    end

    def to_image
      image = MiniMagick::Image.read(IMGKit.new(to_html).to_img)
      image.trim
      image.to_blob
    end
  end

end

