#!/usr/bin/env perl
use common::sense;
use lib './lib';
use Slack::Bot;
use Base::Config;

Slack::Bot->new( token => Base::Config->new( file => 'config.json' )->slack->{rtm} )->run;
