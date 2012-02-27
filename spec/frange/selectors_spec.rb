# -*- coding: utf-8 -*-
require "spec_helper"

module Frange
  module Selectors
    describe NotHashIncluded do
      subject do
        described_selector = described_class
        Frange.draft { |d|
          d.source { |y|
            y << "わぁいなりたあかりなりただいすき"
            y << "わぁいなりたあかりなりたあんまり好きじゃない"
            y << "わぁいなりたあかりなりた結構すき"
          }
          d.selector &described_selector
        }.build(check_hash_file: "/tmp/foo")
      end
      it {
        File.should_receive(:readlines).with("/tmp/foo").at_least(:once).and_return(["わぁいなりたあかりなりたあんまり好きじゃない".hash])
        subject.take(2).should eq ["わぁいなりたあかりなりただいすき", "わぁいなりたあかりなりた結構すき"]
      }
    end
  end
end
