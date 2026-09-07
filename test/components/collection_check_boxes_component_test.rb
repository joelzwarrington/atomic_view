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
    expected = "<div class=\"flex flex-col gap-2\">\n  <input type=\"hidden\" name=\"test_model[tags][]\" value=\"\" autocomplete=\"off\"><div class=\"flex items-center gap-2\"><input class=\"peer border-input dark:bg-input/30 checked:bg-primary checked:text-primary-foreground dark:checked:bg-primary checked:border-primary focus-visible:border-ring focus-visible:ring-ring/50 aria-invalid:ring-destructive/20 dark:aria-invalid:ring-destructive/40 aria-invalid:border-destructive size-4 shrink-0 rounded-[4px] border shadow-xs transition-shadow outline-none focus-visible:ring-[3px] disabled:cursor-not-allowed disabled:opacity-50\" type=\"checkbox\" value=\"ruby\" name=\"test_model[tags][]\" id=\"test_model_tags_ruby\"><label for=\"test_model_tags_ruby\">Ruby</label></div><div class=\"flex items-center gap-2\"><input class=\"peer border-input dark:bg-input/30 checked:bg-primary checked:text-primary-foreground dark:checked:bg-primary checked:border-primary focus-visible:border-ring focus-visible:ring-ring/50 aria-invalid:ring-destructive/20 dark:aria-invalid:ring-destructive/40 aria-invalid:border-destructive size-4 shrink-0 rounded-[4px] border shadow-xs transition-shadow outline-none focus-visible:ring-[3px] disabled:cursor-not-allowed disabled:opacity-50\" type=\"checkbox\" value=\"rails\" name=\"test_model[tags][]\" id=\"test_model_tags_rails\"><label for=\"test_model_tags_rails\">Rails</label></div><div class=\"flex items-center gap-2\"><input class=\"peer border-input dark:bg-input/30 checked:bg-primary checked:text-primary-foreground dark:checked:bg-primary checked:border-primary focus-visible:border-ring focus-visible:ring-ring/50 aria-invalid:ring-destructive/20 dark:aria-invalid:ring-destructive/40 aria-invalid:border-destructive size-4 shrink-0 rounded-[4px] border shadow-xs transition-shadow outline-none focus-visible:ring-[3px] disabled:cursor-not-allowed disabled:opacity-50\" type=\"checkbox\" value=\"javascript\" name=\"test_model[tags][]\" id=\"test_model_tags_javascript\"><label for=\"test_model_tags_javascript\">JavaScript</label></div>\n</div>"

    assert_equal(expected, actual)
  end

  test "renders collection check boxes with custom html options" do
    options = [["Ruby", "ruby"], ["Rails", "rails"], ["JavaScript", "javascript"]]
    actual = render_inline(AtomicView::Components::CollectionCheckBoxesComponent.new(@form, :test_model, :tags, options, :second, :first, {}, {class: "custom-checkbox"})).to_html.strip
    expected = "<div class=\"flex flex-col gap-2\">\n  <input type=\"hidden\" name=\"test_model[tags][]\" value=\"\" autocomplete=\"off\"><div class=\"flex items-center gap-2\"><input class=\"custom-checkbox peer border-input dark:bg-input/30 checked:bg-primary checked:text-primary-foreground dark:checked:bg-primary checked:border-primary focus-visible:border-ring focus-visible:ring-ring/50 aria-invalid:ring-destructive/20 dark:aria-invalid:ring-destructive/40 aria-invalid:border-destructive size-4 shrink-0 rounded-[4px] border shadow-xs transition-shadow outline-none focus-visible:ring-[3px] disabled:cursor-not-allowed disabled:opacity-50\" type=\"checkbox\" value=\"ruby\" name=\"test_model[tags][]\" id=\"test_model_tags_ruby\"><label for=\"test_model_tags_ruby\">Ruby</label></div><div class=\"flex items-center gap-2\"><input class=\"custom-checkbox peer border-input dark:bg-input/30 checked:bg-primary checked:text-primary-foreground dark:checked:bg-primary checked:border-primary focus-visible:border-ring focus-visible:ring-ring/50 aria-invalid:ring-destructive/20 dark:aria-invalid:ring-destructive/40 aria-invalid:border-destructive size-4 shrink-0 rounded-[4px] border shadow-xs transition-shadow outline-none focus-visible:ring-[3px] disabled:cursor-not-allowed disabled:opacity-50\" type=\"checkbox\" value=\"rails\" name=\"test_model[tags][]\" id=\"test_model_tags_rails\"><label for=\"test_model_tags_rails\">Rails</label></div><div class=\"flex items-center gap-2\"><input class=\"custom-checkbox peer border-input dark:bg-input/30 checked:bg-primary checked:text-primary-foreground dark:checked:bg-primary checked:border-primary focus-visible:border-ring focus-visible:ring-ring/50 aria-invalid:ring-destructive/20 dark:aria-invalid:ring-destructive/40 aria-invalid:border-destructive size-4 shrink-0 rounded-[4px] border shadow-xs transition-shadow outline-none focus-visible:ring-[3px] disabled:cursor-not-allowed disabled:opacity-50\" type=\"checkbox\" value=\"javascript\" name=\"test_model[tags][]\" id=\"test_model_tags_javascript\"><label for=\"test_model_tags_javascript\">JavaScript</label></div>\n</div>"

    assert_equal(expected, actual)
  end

  test "renders collection check boxes with object collection" do
    skills = [
      OpenStruct.new(name: "Ruby", id: "ruby"),
      OpenStruct.new(name: "Rails", id: "rails")
    ]
    actual = render_inline(AtomicView::Components::CollectionCheckBoxesComponent.new(@form, :test_model, :skills, skills, :id, :name)).to_html.strip
    expected = "<div class=\"flex flex-col gap-2\">\n  <input type=\"hidden\" name=\"test_model[skills][]\" value=\"\" autocomplete=\"off\"><div class=\"flex items-center gap-2\"><input class=\"peer border-input dark:bg-input/30 checked:bg-primary checked:text-primary-foreground dark:checked:bg-primary checked:border-primary focus-visible:border-ring focus-visible:ring-ring/50 aria-invalid:ring-destructive/20 dark:aria-invalid:ring-destructive/40 aria-invalid:border-destructive size-4 shrink-0 rounded-[4px] border shadow-xs transition-shadow outline-none focus-visible:ring-[3px] disabled:cursor-not-allowed disabled:opacity-50\" type=\"checkbox\" value=\"ruby\" name=\"test_model[skills][]\" id=\"test_model_skills_ruby\"><label for=\"test_model_skills_ruby\">Ruby</label></div><div class=\"flex items-center gap-2\"><input class=\"peer border-input dark:bg-input/30 checked:bg-primary checked:text-primary-foreground dark:checked:bg-primary checked:border-primary focus-visible:border-ring focus-visible:ring-ring/50 aria-invalid:ring-destructive/20 dark:aria-invalid:ring-destructive/40 aria-invalid:border-destructive size-4 shrink-0 rounded-[4px] border shadow-xs transition-shadow outline-none focus-visible:ring-[3px] disabled:cursor-not-allowed disabled:opacity-50\" type=\"checkbox\" value=\"rails\" name=\"test_model[skills][]\" id=\"test_model_skills_rails\"><label for=\"test_model_skills_rails\">Rails</label></div>\n</div>"

    assert_equal(expected, actual)
  end

  test "renders collection check boxes with different field name" do
    options = [["Beginner", "beginner"], ["Intermediate", "intermediate"], ["Advanced", "advanced"]]
    actual = render_inline(AtomicView::Components::CollectionCheckBoxesComponent.new(@form, :test_model, :skills, options, :second, :first)).to_html.strip
    expected = "<div class=\"flex flex-col gap-2\">\n  <input type=\"hidden\" name=\"test_model[skills][]\" value=\"\" autocomplete=\"off\"><div class=\"flex items-center gap-2\"><input class=\"peer border-input dark:bg-input/30 checked:bg-primary checked:text-primary-foreground dark:checked:bg-primary checked:border-primary focus-visible:border-ring focus-visible:ring-ring/50 aria-invalid:ring-destructive/20 dark:aria-invalid:ring-destructive/40 aria-invalid:border-destructive size-4 shrink-0 rounded-[4px] border shadow-xs transition-shadow outline-none focus-visible:ring-[3px] disabled:cursor-not-allowed disabled:opacity-50\" type=\"checkbox\" value=\"beginner\" name=\"test_model[skills][]\" id=\"test_model_skills_beginner\"><label for=\"test_model_skills_beginner\">Beginner</label></div><div class=\"flex items-center gap-2\"><input class=\"peer border-input dark:bg-input/30 checked:bg-primary checked:text-primary-foreground dark:checked:bg-primary checked:border-primary focus-visible:border-ring focus-visible:ring-ring/50 aria-invalid:ring-destructive/20 dark:aria-invalid:ring-destructive/40 aria-invalid:border-destructive size-4 shrink-0 rounded-[4px] border shadow-xs transition-shadow outline-none focus-visible:ring-[3px] disabled:cursor-not-allowed disabled:opacity-50\" type=\"checkbox\" value=\"intermediate\" name=\"test_model[skills][]\" id=\"test_model_skills_intermediate\"><label for=\"test_model_skills_intermediate\">Intermediate</label></div><div class=\"flex items-center gap-2\"><input class=\"peer border-input dark:bg-input/30 checked:bg-primary checked:text-primary-foreground dark:checked:bg-primary checked:border-primary focus-visible:border-ring focus-visible:ring-ring/50 aria-invalid:ring-destructive/20 dark:aria-invalid:ring-destructive/40 aria-invalid:border-destructive size-4 shrink-0 rounded-[4px] border shadow-xs transition-shadow outline-none focus-visible:ring-[3px] disabled:cursor-not-allowed disabled:opacity-50\" type=\"checkbox\" value=\"advanced\" name=\"test_model[skills][]\" id=\"test_model_skills_advanced\"><label for=\"test_model_skills_advanced\">Advanced</label></div>\n</div>"

    assert_equal(expected, actual)
  end

  test "renders collection check boxes with data attributes" do
    options = [["Ruby", "ruby"], ["Rails", "rails"]]
    actual = render_inline(AtomicView::Components::CollectionCheckBoxesComponent.new(@form, :test_model, :tags, options, :second, :first, {}, {data: {action: "change->controller#update"}})).to_html.strip
    expected = "<div class=\"flex flex-col gap-2\">\n  <input type=\"hidden\" name=\"test_model[tags][]\" value=\"\" autocomplete=\"off\"><div class=\"flex items-center gap-2\"><input data-action=\"change->controller#update\" class=\"peer border-input dark:bg-input/30 checked:bg-primary checked:text-primary-foreground dark:checked:bg-primary checked:border-primary focus-visible:border-ring focus-visible:ring-ring/50 aria-invalid:ring-destructive/20 dark:aria-invalid:ring-destructive/40 aria-invalid:border-destructive size-4 shrink-0 rounded-[4px] border shadow-xs transition-shadow outline-none focus-visible:ring-[3px] disabled:cursor-not-allowed disabled:opacity-50\" type=\"checkbox\" value=\"ruby\" name=\"test_model[tags][]\" id=\"test_model_tags_ruby\"><label for=\"test_model_tags_ruby\">Ruby</label></div><div class=\"flex items-center gap-2\"><input data-action=\"change->controller#update\" class=\"peer border-input dark:bg-input/30 checked:bg-primary checked:text-primary-foreground dark:checked:bg-primary checked:border-primary focus-visible:border-ring focus-visible:ring-ring/50 aria-invalid:ring-destructive/20 dark:aria-invalid:ring-destructive/40 aria-invalid:border-destructive size-4 shrink-0 rounded-[4px] border shadow-xs transition-shadow outline-none focus-visible:ring-[3px] disabled:cursor-not-allowed disabled:opacity-50\" type=\"checkbox\" value=\"rails\" name=\"test_model[tags][]\" id=\"test_model_tags_rails\"><label for=\"test_model_tags_rails\">Rails</label></div>\n</div>"

    assert_equal(expected, actual)
  end

  test "renders empty collection gracefully" do
    actual = render_inline(AtomicView::Components::CollectionCheckBoxesComponent.new(@form, :test_model, :tags, [], :second, :first)).to_html.strip
    expected = <<~HTML.strip
      <div class="flex flex-col gap-2">
        <input type="hidden" name="test_model[tags][]" value="" autocomplete="off">
      </div>
    HTML

    assert_equal(expected, actual)
  end
end
