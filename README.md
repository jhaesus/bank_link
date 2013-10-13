# BankLink [![Gem Version](https://badge.fury.io/rb/bank_link.png)](https://rubygems.org/gems/bank_link) [![Build Status](https://travis-ci.org/jhaesus/bank_link.png?branch=master)](https://travis-ci.org/jhaesus/bank_link) [![Dependency Status](https://gemnasium.com/jhaesus/bank_link.png)](https://gemnasium.com/jhaesus/bank_link)

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
  config.default_encoding = "UTF-8" #used only if link.data.encoding_key is set

  config.links(:name_of_link, "https://url.of.link") do |data, form|
    form[:VK_SERVICE] = "1001"
    form[:VK_VERSION] = "008"
    form[:VK_AMOUNT] = Proc.new { |link, object| object.price }
    form[:VK_CURR] = "EUR"
```
#### Additional Options
##### Encoding
```ruby
    data.encoding_key = "VK_CHARSET"
    data.encoding_key = "VK_ENCODING"
    data.encoding = "UTF-8"
```
##### Mac
```ruby
    data.mac_class = BankLink::Mac::VK #default
    data.mac_key = File.read("my/private_key.pem")
    data.mac_key_passphrase = File.read("my_password")
    data.algorithm = OpenSSL::Digest::SHA1 #default for VK

    data.mac_class = BankLink::Mac::Solo
    data.mac_key = File.read("my_key.txt")
    data.algorithm = OpenSSL::Digest::MD5 #default for Solo



    data.mac_class = BankLink::Mac::Custom
```
### View Helper
```haml
= bank_links @object do |link|
  = submit_tag(link.name)
```
```haml
- BankLink.each do |link|
  = bank_link_tag link, @object do
    = submit_tag(link.name)
```
#### Additional Options
##### Override/Set Form Values
```haml
- BankLink.each do |link|
  = bank_link_tag link, @object, { :values => {:VK_AMOUNT => @object.price }} do
    = submit_tag
```
##### Override/Set Form Attributes
```haml
- BankLink.each do |link|
  = bank_link_tag link, @object, { :form => {:method => :get }} do
    = submit_tag
```

### Additional Info
[Pangalink.net](https://pangalink.net/info)
#### Documentations
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