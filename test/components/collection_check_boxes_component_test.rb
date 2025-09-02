# frozen_string_literal: true

require "test_helper"

class AtomicView::Components::CollectionCheckBoxesComponentTest < ViewComponent::TestCase
  class TestModel
    include ActiveModel::Model
    include ActiveModel::Attributes

    attribute :tags, default: -> { [] }
    attribute :skills, default: -> { [] }

    def errors
      @errors ||= ActiveModel::Errors.new(self)
    end
  end

  def setup
    @object = TestModel.new
    @form = ActionView::Helpers::FormBuilder.new(:test_model, @object, vc_test_controller.view_context, {})
  end

  test "renders basic collection check boxes" do
    options = [["Ruby", "ruby"], ["Rails", "rails"], ["JavaScript", "javascript"]]
    actual = render_inline(AtomicView::Components::CollectionCheckBoxesComponent.new(@form, :test_model, :tags, options, :second, :first)).to_html.strip
    expected = <<~HTML.strip
      <input type="hidden" name="test_model[tags][]" value="" autocomplete="off"><input type="checkbox" value="ruby" name="test_model[tags][]" id="test_model_tags_ruby"><label for="test_model_tags_ruby">Ruby</label><input type="checkbox" value="rails" name="test_model[tags][]" id="test_model_tags_rails"><label for="test_model_tags_rails">Rails</label><input type="checkbox" value="javascript" name="test_model[tags][]" id="test_model_tags_javascript"><label for="test_model_tags_javascript">JavaScript</label>
    HTML

    assert_equal(expected, actual)
  end

  test "renders collection check boxes with custom html options" do
    options = [["Ruby", "ruby"], ["Rails", "rails"], ["JavaScript", "javascript"]]
    actual = render_inline(AtomicView::Components::CollectionCheckBoxesComponent.new(@form, :test_model, :tags, options, :second, :first, {}, {class: "custom-checkbox"})).to_html.strip
    expected = <<~HTML.strip
      <input type="hidden" name="test_model[tags][]" value="" autocomplete="off"><input class="custom-checkbox" type="checkbox" value="ruby" name="test_model[tags][]" id="test_model_tags_ruby"><label for="test_model_tags_ruby">Ruby</label><input class="custom-checkbox" type="checkbox" value="rails" name="test_model[tags][]" id="test_model_tags_rails"><label for="test_model_tags_rails">Rails</label><input class="custom-checkbox" type="checkbox" value="javascript" name="test_model[tags][]" id="test_model_tags_javascript"><label for="test_model_tags_javascript">JavaScript</label>
    HTML

    assert_equal(expected, actual)
  end

  test "renders collection check boxes with object collection" do
    skills = [
      OpenStruct.new(name: "Ruby", id: "ruby"),
      OpenStruct.new(name: "Rails", id: "rails")
    ]
    actual = render_inline(AtomicView::Components::CollectionCheckBoxesComponent.new(@form, :test_model, :skills, skills, :id, :name)).to_html.strip
    expected = <<~HTML.strip
      <input type="hidden" name="test_model[skills][]" value="" autocomplete="off"><input type="checkbox" value="ruby" name="test_model[skills][]" id="test_model_skills_ruby"><label for="test_model_skills_ruby">Ruby</label><input type="checkbox" value="rails" name="test_model[skills][]" id="test_model_skills_rails"><label for="test_model_skills_rails">Rails</label>
    HTML

    assert_equal(expected, actual)
  end

  test "renders collection check boxes with different field name" do
    options = [["Beginner", "beginner"], ["Intermediate", "intermediate"], ["Advanced", "advanced"]]
    actual = render_inline(AtomicView::Components::CollectionCheckBoxesComponent.new(@form, :test_model, :skills, options, :second, :first)).to_html.strip
    expected = <<~HTML.strip
      <input type="hidden" name="test_model[skills][]" value="" autocomplete="off"><input type="checkbox" value="beginner" name="test_model[skills][]" id="test_model_skills_beginner"><label for="test_model_skills_beginner">Beginner</label><input type="checkbox" value="intermediate" name="test_model[skills][]" id="test_model_skills_intermediate"><label for="test_model_skills_intermediate">Intermediate</label><input type="checkbox" value="advanced" name="test_model[skills][]" id="test_model_skills_advanced"><label for="test_model_skills_advanced">Advanced</label>
    HTML

    assert_equal(expected, actual)
  end

  test "renders collection check boxes with data attributes" do
    options = [["Ruby", "ruby"], ["Rails", "rails"]]
    actual = render_inline(AtomicView::Components::CollectionCheckBoxesComponent.new(@form, :test_model, :tags, options, :second, :first, {}, {data: {action: "change->controller#update"}})).to_html.strip
    expected = <<~HTML.strip
      <input type="hidden" name="test_model[tags][]" value="" autocomplete="off"><input data-action="change-&gt;controller#update" type="checkbox" value="ruby" name="test_model[tags][]" id="test_model_tags_ruby"><label for="test_model_tags_ruby">Ruby</label><input data-action="change-&gt;controller#update" type="checkbox" value="rails" name="test_model[tags][]" id="test_model_tags_rails"><label for="test_model_tags_rails">Rails</label>
    HTML

    assert_equal(expected, actual)
  end

  test "renders empty collection gracefully" do
    actual = render_inline(AtomicView::Components::CollectionCheckBoxesComponent.new(@form, :test_model, :tags, [], :second, :first)).to_html.strip
    expected = <<~HTML.strip
      <input type="hidden" name="test_model[tags][]" value="" autocomplete="off">
    HTML

    assert_equal(expected, actual)
  end
end
