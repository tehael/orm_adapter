require 'spec_helper'
require 'orm_adapter/example_app_shared'

if !defined?(CouchrestModel) || !(CouchRest.database!("http://admin:admin@127.0.0.1:5984/orm_adapter_spec") rescue nil)
  puts "** require 'couchrest_model' start CouchDB to run the specs in #{__FILE__}"
else  
  
  module CouchrestModelOrmSpec
    class User < CouchRest::Model::Base
      use_database CouchRest.database!("http://admin:admin@127.0.0.1:5984/orm_adapter_spec")
      
      property :name
      #collection_of :notes, CouchrestModelOrmSpec::Note
    end

    class Note < CouchRest::Model::Base
      use_database CouchRest.database!("http://admin:admin@127.0.0.1:5984/orm_adapter_spec")

      property :body, :default => "made by orm"
      #belongs_to :user, CouchrestModelOrmSpec::User
    end
    
    # here be the specs!
    describe CouchRest::Model::Base::OrmAdapter do
      before do
        User.delete_all
        Note.delete_all
      end
      
      describe "the OrmAdapter class" do
        subject { CouchRest::Model::Base::OrmAdapter }

        specify "#model_classes should return all document classes" do
          (subject.model_classes & [User, Note]).to_set.should == [User, Note].to_set
        end
      end
    
      it_should_behave_like "example app with orm_adapter" do
        let(:user_class) { User }
        let(:note_class) { Note }
      end
    end
  end
end
