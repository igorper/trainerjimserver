# Usage:
# > load(Rails.application.root.join('lib/everkinetic_import.rb'))
# > EverkineticImport::import_from("#{Dir.home}/Downloads/everkinetic")
require 'set'

module EverkineticImport

  def self.import_from(path)
    found_exercises = Dir.glob("#{path}/db.everkinetic.com/exercise/*/index.html")
                          .map { |f| Nokogiri::HTML(File.read(f)) }
                          .map do |html|
      {
          title: html.at_css('.entry-title a').inner_text,
          type: get_taxonomy(html, 'Type'),
          primary: get_taxonomy(html, 'Primary'),
          secondary: get_taxonomy(html, 'Secondary'),
          equipment: get_taxonomy(html, 'Equipment'),
          images: get_images(html),
          content: get_content(html).to_html
      }
    end

    {
        exercises: found_exercises,
        primary: found_exercises.reduce(SortedSet.new) { |types, ex| types.merge(ex[:primary]) },
        equipment: found_exercises.reduce(SortedSet.new) { |types, ex| types.merge(ex[:equipment]) }
    }
  end

  def self.get_content(html)
    html.at_css('div.exercise-entry-content')
        .element_children
        .take_while { |child| !'exercise-taxonomies'.in?(child['class'].to_s) }
        .reduce(Nokogiri::HTML::DocumentFragment.parse '') { |content, child| content << child }
  end

  def self.get_taxonomy(exercise_page_html, taxonomy_type)
    get_data(exercise_page_html, 'exercise-taxonomies', taxonomy_type)
        .map { |a| a.inner_text }
  end

  def self.get_images(exercise_page_html)
    get_data(exercise_page_html, 'download-exercise-images', 'Large')
        .map { |a| a['href'] }
  end

  def self.get_data(exercise_page_html, data_type, sub_data_type)
    exercise_page_html.css("ul.#{data_type} > li")
        .select { |li| li.css('strong').any? { |type| sub_data_type.in?(type.inner_text) } }
        .flat_map { |li| li.css('a') }
  end
end