# Usage:
# > load(Rails.application.root.join('lib/everkinetic_import.rb'))
# > EverkineticImport::import_from("#{Dir.home}/Downloads/everkinetic")
# To delete old exercises:
# > EverkineticImport::delete_old_exercise_types()
require 'set'

module EverkineticImport

  EQUIPMENT_GROUPS = {
      'balance board' => nil,
      'band' => 'Band',
      'bands' => 'Band',
      'bar' => 'Barbell',
      'barbell' => 'Barbell',
      'barbell or dumbbell' => 'Dumbbell',
      'bench' => nil,
      'bench press machine' => 'Machine',
      'body' => 'Bodyweight',
      'bosu ball' => 'Stability Ball',
      'butterfly machine' => 'Machine',
      'cable' => 'Machine',
      'cable machine' => 'Machine',
      'chest machine' => 'Machine',
      'decline bench' => nil,
      'dumbbell' => 'Dumbbell',
      'dumbbells' => 'Dumbbell',
      'dumbell' => 'Dumbbell',
      'exercise ball' => 'Stability Ball',
      'exercise band' => 'Band',
      'flat bench' => nil,
      'hyperextension bench' => nil,
      'incline bench' => nil,
      'machine' => 'Machine',
      'medicine ball' => 'Stability Ball',
      'parallel bars' => 'Barbell',
      'smith machine' => 'Machine',
      'stability ball' => 'Stability Ball',
      'swiss ball' => 'Stability Ball',
      't-bar machine' => 'Machine',
      'weight' => 'Dumbbell',
      'weight plate' => 'Dumbbell'
  }

  MUSCLE_GROUPS = {
      'abdominals' => 'Core',
      'arms' => 'Arms',
      'back' => 'Back',
      'biceps' => 'Arms',
      'calves' => 'Legs',
      'chest' => 'Chest',
      'core' => 'Core',
      'gluts' => 'Legs',
      'hamstring' => 'Legs',
      'hamstrings' => 'Legs',
      'lateral deltoid' => 'Shoulders',
      'lats' => 'Back',
      'lower abdominals' => 'Core',
      'lower back' => 'Back',
      'middle back' => 'Back',
      'neck extensors' => 'Shoulders',
      'neck flexors' => 'Shoulders',
      'neck side flexors' => 'Shoulders',
      'obliques' => 'Core',
      'posterior deltoid' => 'Shoulders',
      'quadriceps' => 'Legs',
      'rear deltoid' => 'Shoulders',
      'shoulders' => 'Shoulders',
      'trapezius' => 'Back',
      'triceps' => 'Arms'
  }

  GROUPS = MUSCLE_GROUPS.merge(EQUIPMENT_GROUPS)

  def self.import_from(path)
    img_file = Tempfile.create(['exercise_image', '.png'])
    img_file.close
    temp_path = img_file.path

    load_exercises(path).map do |exercise|
      ExerciseType.create(
          name: exercise[:title],
          exercise_groups: get_exercise_groups(exercise, :primary) + get_exercise_groups(exercise, :equipment),
          description: exercise[:content],
          user_exercise_photos: exercise[:images].map do |img|
            FileUtils::copy(img, temp_path)
            File.open(temp_path) do |f|
              UserExercisePhoto.create(photo: f)
            end
          end
      )
    end
  end

  def self.delete_old_exercise_types(path)
    ExerciseType.all.each do |exercise_type|
      if exercise_type.description.nil?
        begin
          exercise_type.delete
        rescue
          # ignored
        end
      end
    end
  end

  def self.load_exercises(path)
    Dir.glob("#{path}/db.everkinetic.com/exercise/*/index.html")
        .map { |f| Nokogiri::HTML(File.read(f)) }
        .map do |html|
      {
          title: html.at_css('.entry-title a').inner_text,
          type: get_taxonomy(html, 'Type'),
          primary: get_taxonomy(html, 'Primary'),
          secondary: get_taxonomy(html, 'Secondary'),
          equipment: get_taxonomy(html, 'Equipment'),
          images: get_images(html, path),
          content: get_content(html).to_html
      }
    end
  end

  def self.get_exercise_groups(exercise, taxonomy_type)
    exercise[taxonomy_type].map { |t| EverkineticImport::GROUPS[t] }
        .compact
        .map { |t| ExerciseGroup.find_by_name(t) }
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

  def self.get_images(exercise_page_html, base_dir)
    get_data(exercise_page_html, 'download-exercise-images', 'Large')
        .map { |a| a['href'] }
        .map { |rel_path| File.join(base_dir, rel_path[9..-1]) }
  end

  def self.get_data(exercise_page_html, data_type, sub_data_type)
    exercise_page_html.css("ul.#{data_type} > li")
        .select { |li| li.css('strong').any? { |type| sub_data_type.in?(type.inner_text) } }
        .flat_map { |li| li.css('a') }
  end
end