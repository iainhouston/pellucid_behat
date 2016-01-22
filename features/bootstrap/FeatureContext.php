<?php

use Drupal\DrupalExtension\Context\RawDrupalContext;
use Behat\Behat\Context\SnippetAcceptingContext;
use Behat\Behat\Hook\Scope\AfterScenarioScope;
use Behat\Behat\Hook\Scope\BeforeScenarioScope;
use Behat\Gherkin\Node\PyStringNode;
use Behat\Gherkin\Node\TableNode;
use Behat\Behat\Tester\Exception\PendingException;

/**
 * Defines application features from the specific context.
 */
class FeatureContext extends RawDrupalContext implements SnippetAcceptingContext {

  private $m_config; // \Drupal\Core\Config\ConfigFactoryInterface
  private $saved_mailsystem_defaults;
  private $saved_interface_default;
  private $last_mail;

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
   * @Then an email should be sent
   */
  public function anEmailShouldBeSent()
  {
    \Drupal::state()->resetCache();
    $mails = \Drupal::state()->get('system.test_mail_collector') ?: array();
    $last_mail = end($mails);
    if(!$last_mail) {
      throw new Exception('No mail was sent.');
    }
    $this->lastMail = $last_mail;
  }

  /**
   *  @Then an email should be sent to :recipient
   */
  public function anEmailShouldBeSentTo($recipient)
  {
    // Retrieve sent message.
    $mails = \Drupal::state()->get('system.test_mail_collector');
    $last_mail = end($mails);
    if(!$last_mail) {
      throw new Exception('No mail was sent.');
    }
    if ($last_mail['to'] != $recipient) {
      throw new \Exception("Unexpected recpient: " . $last_mail['to']);
    }
    $this->lastMail = $last_mail;
  }

  /** 
   *  @BeforeScenario @email
   */
  public function beforeEmailScenario(BeforeScenarioScope $scope)
  {
    $this->m_config = \Drupal::configFactory()->getEditable('mailsystem.settings');
    // $this->m_config = \Drupal::configFactory()->getEditable('system.mail');
    $this->saved_mailsystem_defaults = $this->m_config->get('defaults'); 
    // $this->saved_interface_default = $this->m_config->get('default'); 
    // print_r($this->saved_interface_default);
    $this->m_config->set('defaults.sender', 'test_mail_collector')->save();

    // $this->m_config->set('interface.default', 'test_mail_collector')->save();

    // Reset the state variable that holds sent messages.
    \Drupal::state()->set('system.test_mail_collector', array());
    $language_interface = \Drupal::languageManager()->getCurrentLanguage();
    \Drupal::service('plugin.manager.mail')->mail('simpletest', 'cancel_test', 'cancel@example.com', $language_interface->getId());
  }

  /** 
   *  @AfterScenario @email 
   */
  public function afterEmailScenario(AfterScenarioScope $scope)
  {
    // revert mail system after scenarios agged with @email
    $this->m_config->set('defaults.sender', $this->saved_mailsystem_defaults['sender'])->save();
    // $this->m_config->set('interface.default', $this->saved_interface_default)->save();
    // print_r($this->saved_interface_default);
  }
}
