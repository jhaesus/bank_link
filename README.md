# BankLink [![Gem Version](https://badge.fury.io/rb/bank_link.png)](https://rubygems.org/gems/bank_link) [![Build Status](https://travis-ci.org/jhaesus/bank_link.png?branch=master)](https://travis-ci.org/jhaesus/bank_link) [![Dependency Status](https://gemnasium.com/jhaesus/bank_link.png)](https://gemnasium.com/jhaesus/bank_link) [![Code Climate](https://codeclimate.com/github/jhaesus/bank_link.png)](https://codeclimate.com/github/jhaesus/bank_link)

Helper gem to simplify bank link usage in Rails projects

## Installation

Add this line to your application's Gemfile:
```ruby
gem 'bank_link'
```
And then execute:
```bash
$ bundle
```
Or install it yourself as:
```bash
$ gem install bank_link
```
## Usage

### Set Up Initializer
```ruby
BankLink.configuration do |config|
```
```ruby
BankLink do |config|
```
#### Override mac fields if you so wish
Defaults can be found in [mac_fields.yml](https://github.com/jhaesus/bank_link/blob/master/mac_fields.yml)
```ruby
  config.mac_fields do |mac_fields|
    mac_fields.SOLOPMT_VERSION[:request]["0003"] = [
      :VERSION,
      :STAMP,
      :RCV_ID,
      :AMOUNT,
      :REF,
      :DATE,
      :CUR
    ]
  end
```
#### Add banks
```ruby
  config.banks :name_of_bank do |bank|
```
##### Change bank settings
```ruby
    bank.settings do |settings|
```
###### Encoding
```ruby
      settings.encoding_key = "VK_CHARSET"
      settings.encoding = "UTF-8"
```
###### Private/Public keys and passphrases
```ruby
      settings.private_key = File.read("my/private_key.pem")
      settings.private_key_passphrase = File.read("my_password")
      settings.public_key = File.read("bank/certificate")
```
###### Mac calculation settings
```ruby
      settings.mac_class = BankLink::Mac::VK
      settings.digest = OpenSSL::Digest::SHA1

      settings.mac_class = BankLink::Mac::Solo
      settings.digest = OpenSSL::Digest::MD5

      settings.mac_class = BankLink::Mac::Custom #Or roll your own
    end
```
##### Add link(s)
All the correct form fields can be found in various bank documentations, [listed below](https://github.com/jhaesus/bank_link/edit/master/README.md#additional-info). "Have fun"
```ruby
    bank.payment_link "https://url.of.link" do |form|
      form[:VK_SERVICE] = "1001"
      form[:VK_VERSION] = "008"
      form[:VK_AMOUNT] = Proc.new { |link, object| object.price }
      form[:VK_CURR] = "EUR"
    end
    bank.authorization_link "https://url.of.link/auth" do |form|
      form[:VK_SERVICE] = "1001"
      form[:VK_VERSION] = "008"
    end
```
### View Helper
```haml
= payment_links @object do |link|
  = submit_tag(link.bank.name)
```
```haml
- BankLink.payment_links do |link|
  = bank_link_tag link, @object do
    = submit_tag(link.bank.name)
```
#### Override/Set Form Values
```haml
- payment_links @object, { :values => { :VK_AMOUNT => Proc.new { |link, object| object.price * 2 } }} do |link|
  = submit_tag
```
```haml
- BankLink.payment_links do |link|
  = bank_link_tag link, @object, { :values => {:VK_AMOUNT => @object.price }} do
    = submit_tag
```
#### Override/Set Form Attributes
```haml
- payment_links @object, { :form => { :data => { :something => "other" } } } do |link|
  = submit_tag
```
```haml
- BankLink.payment_links do |link|
  = bank_link_tag link, @object, { :form => {:method => :get }} do
    = submit_tag
```
### Verifying Responses
```ruby
  link = BankLink.configuration.banks.name_of_link
  link.verify params
```

## Additional Info
[Pangalink.net](https://pangalink.net/info)
### Documentations
- [Danske Bank Documentation](http://www.danskebank.ee/et/14732.html)
- [Krediidipank Documentation](http://www.krediidipank.ee/business/settlements/bank-link/tehniline_kirjeldus.pdf)
- [LHV Documentation](http://www.lhv.ee/images/docs/Bank_Link_Technical_Specification-ET.pdf)
- [Nordea Documentation](http://www.nordea.ee/sitemod/upload/root/www.nordea.ee%20-%20default/Teenused%20firmale/E-Payment_v1_1.pdf)
- [SEB Documentation](http://www.seb.ee/ari/maksete-kogumine/maksete-kogumine-internetis/tehniline-spetsifikatsioon)
- [Swedbank Documentation](https://www.swedbank.ee/static/pdf/business/d2d/paymentcollection/info_banklink_techspec_est.pdf)

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

[![GA](http://ga.webdigi.co.uk/fbga.php?googlecode=UA-44875948-6&pagelink=https%3A//github.com/jhaesus/bank_link&pagetitle=jhaesus/bank_link)](https://github.com/jhaesus/bank_link)