require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase
  test "should return existing translations for default locales" do
    oldLocale = I18n.locale
    I18n.locale = :en
    assert_equal(i18n_strings(:article_title_en).data, jim_t('article.title'))
    
    I18n.locale = :si
    assert_equal(i18n_strings(:article_title_si).data, jim_t('article.title'))
    assert_equal(i18n_strings(:article_content_si).data, jim_t('article.content'))
    
    I18n.locale = oldLocale
  end
  
  test "should return existing translations for given locales" do
    assert_equal(i18n_strings(:article_title_en).data, jim_t('article.title', :en))
    assert_equal(i18n_strings(:article_title_si).data, jim_t('article.title', :si))
    assert_equal(i18n_strings(:article_content_si).data, jim_t('article.content', :si))
  end
  
  test "should return the key if the translation is missing" do
    assert_equal("A missing translation...", jim_t('A missing translation...', :en))
    assert_equal("B missing translation...", jim_t('B missing translation...', :si))
    assert_equal("C missing translation...", jim_t('C missing translation...'))
  end
end
