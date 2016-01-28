<?php

use Drupal\DrupalExtension\Context\RawDrupalContext;
use Behat\Behat\Context\SnippetAcceptingContext;
use Behat\Behat\Hook\Scope\AfterScenarioScope;
use Behat\Behat\Hook\Scope\BeforeScenarioScope;

/**
 * Defines application features from the specific context.
 */
class FeatureContext extends RawDrupalContext implements SnippetAcceptingContext {

  private $m_config; // \Drupal\Core\Config\ConfigFactoryInterface
  private $saved_mailsystem_defaults;
  private $h_config; // \Drupal\Core\Config\ConfigFactoryInterface
  private $saved_honeypot_time_limit;
  private $lastMail;

  /**
   * Initializes context.
   *
   * Every scenario gets its own context instance.
   * You can also pass arbitrary arguments to the
   * context constructor through behat.yml.
   */
  public function __construct() {
  }

  /**
   * @Given /^I wait (for )([0-9^"]*) second(s)$/
   */
  public function iWaitSeconds($wait) {
    for ($i = 0; $i < $wait; $i++) {
      sleep(1);
    }
  }

  /**
   * This works for Selenium and other real browsers that support screenshots.
   *
   * @Then /^show me a screenshot$/
   */
  public function show_me_a_screenshot() {

    $image_data = $this->getSession()->getDriver()->getScreenshot();
    $file_and_path = '/tmp/behat_screenshot.jpg';
    file_put_contents($file_and_path, $image_data);

    //if (PHP_OS === "Darwin" && PHP_SAPI === "cli") {
    exec('open -a "Preview.app" ' . $file_and_path);
    //}
  }

  /**
   * This works for the Goutte driver and I assume other HTML-only ones.
   *
   * @Then /^show me the HTML page$/
   */
  public function show_me_the_html_page_in_the_browser() {

    $html_data = $this->getSession()->getDriver()->getContent();
    $file_and_path = '/tmp/behat_page.html';
    file_put_contents($file_and_path, $html_data);

    exec('open -a "Safari.app" ' . $file_and_path);

  }


  /**
   * @Then an email should be sent
   */
  public function anEmailShouldBeSent() {
    // Reset state cache.
    \Drupal::state()->resetCache();
    $mails = \Drupal::state()->get('system.test_mail_collector') ?: array();
    $last_mail = end($mails);
    if (!$last_mail) {
      throw new Exception('No mail was sent.');
    }
    $this->lastMail = $last_mail;
  }

  /**
   * @Then an email should be sent to :recipient
   */
  public function anEmailShouldBeSentTo($recipient) {
    // Reset state cache.
    \Drupal::state()->resetCache();
    // Retrieve sent message.
    $mails = \Drupal::state()->get('system.test_mail_collector');
    $last_mail = end($mails);
    if (!$last_mail) {
      throw new Exception('No mail was sent.');
    }
    if ($last_mail['to'] != $recipient) {
      throw new \Exception("Unexpected recpient: " . $last_mail['to']);
    }
    $this->lastMail = $last_mail;
  }

  /**
   * @BeforeScenario @email
   */
  public function beforeEmailScenario(BeforeScenarioScope $scope) {
    $this->m_config = \Drupal::configFactory()
      ->getEditable('mailsystem.settings');
    $this->saved_mailsystem_defaults = $this->m_config->get('defaults');
    $this->m_config
      ->set('defaults.sender', 'test_mail_collector')
      ->set('defaults.formatter', 'test_mail_collector')
      ->save();
    // Reset the state variable that holds sent messages.
    \Drupal::state()->set('system.test_mail_collector', array());

    // If we have honeypot installed then ensure that we disable time_limit
    // So that automated tests / bots can run  
    $this->h_config = \Drupal::configFactory()
      ->getEditable('honeypot.settings');
    $this->saved_honeypot_time_limit = $this->h_config->get('time_limit');
    if ($this->saved_honeypot_time_limit) {
      $this->h_config
        ->set('time_limit', '0')
        ->save();
    }
  }

  /**
   * @AfterScenario @email
   */
  public function afterEmailScenario(AfterScenarioScope $scope) {
    // revert mail system after scenarios agged with @email
    $this->m_config
      ->set('defaults.sender', $this->saved_mailsystem_defaults['sender'])
      ->set('defaults.formatter', $this->saved_mailsystem_defaults['formatter'])
      ->save();

    // Ensure we protect against spambots again if honeypot is installed
    if ($this->saved_honeypot_time_limit) {
      $this->h_config
        ->set('time_limit', $this->saved_honeypot_time_limit)
        ->save();
    }
  }
}