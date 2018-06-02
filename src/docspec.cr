require "./docspec/*"

# The main module of the docspec library.
#
# Refer to the top level README for usage.
module Docspec
  DOCTEST_PREFIX           = /^>>/
  DOCTEST_RESULT_PREFIX    = /# =>/
  COMMENT_REGEX            = /^\s*#/
  CODEBLOCK_REGEX          = /^\s*#\s*```/
  DOCTEST_ANNOTATION_REGEX = /^\s*#\s?\[\]\(@doctest\)/

  # Parses *filename* for marked examples to create specs.
  macro doctest(filename)
    {% calling_dir = filename.filename.gsub(/[^\/]*$/, "") %}\
    {% parser = {mode: :default, doctest_all: false} %}\
    {% for line, index in `cd #{calling_dir} && cat #{filename}`.lines %}\
      {% if line =~ Docspec::CODEBLOCK_REGEX %}\
        {% parser[:mode] = (parser[:mode] == :codeblock) ? :default : :codeblock %}\
      {% elsif line =~ Docspec::DOCTEST_ANNOTATION_REGEX %}\
        {% parser[:doctest_all] = true %}\
      {% elsif line =~ Docspec::COMMENT_REGEX %}\
        {% if parser[:mode] == :codeblock %}\
          Docspec.doctest_code_line({{line.strip}}, {{filename}}, {{index + 1}}, {{parser}})
        {% else %}\
          {% parser[:doctest_all] = false %}\
          Docspec.doctest_comment({{line.strip}}, {{filename}}, {{index + 1}})
        {% end %}\
      {% elsif !line.strip.empty? %}\
        {% parser[:mode] = :default %}\
        {% parser[:doctest_all] = false %}\
      {% end %}\
    {% end %}\
  end

  # :nodoc:
  macro doctest_comment(line, filename, row)
    {% no_comment_line = line.strip.gsub(/^#/, "") %}\
    {% if no_comment_line =~ /^ {5,}/ %}\
      {% example = no_comment_line.gsub(/^ {5,}/, "") %}\
      Docspec.doctest_example({{example}}, {{filename}}, {{row}})
    {% end %}\
  end

  # :nodoc:
  macro doctest_code_line(line, filename, row, parser)
    {% no_comment_line = line.strip.gsub(/^#/, "") %}\
    Docspec.doctest_example({{no_comment_line}}, {{filename}}, {{row}}, {{parser}})
  end

  # :nodoc:
  macro doctest_example(line, filename, row, parser)
    {% if parser[:doctest_all] || line.strip =~ Docspec::DOCTEST_PREFIX %}\
      Docspec.doctest_marked_example({{line}}, {{filename}}, {{row}})
    {% end %}\
  end

  # :nodoc:
  macro doctest_marked_example(line, filename, row)
    {% doc_expr = line.strip.gsub(Docspec::DOCTEST_PREFIX, "").strip %}\
    {% result_expr = doc_expr.strip.gsub(Docspec::DOCTEST_RESULT_PREFIX, "# =>").strip %}\
    {% expr_tokens = result_expr.split("# =>") %}\
    {% if expr_tokens.size == 1 %}
      # {{filename.id}}:{{row.id}}
      {{doc_expr.id.strip}}
    {% else %}\
      {% for token, index in expr_tokens %}\
        {% if index == 0 %}
          # {{filename.id}}:{{row.id}}
          observed = ({{token.id.strip}})
        {% else %}
          describe %(Docspec {{filename.id}}:{{row.id}}) do
            it %(({{expr_tokens[0].id.strip}} # => {{token.id.strip}})) do
              expected = {{token.id.strip}}
              observed.should eq expected
            end
          end
        {% end %}\
      {% end %}\
    {% end %}\
  end
end
