# Guppi - a simple Google AJAX API helper for Rails
# Anthony M. Cook - anthonymichaelcook@gmail.com

module Guppi
  def google_api_key
    # FIXME: pull this from the app's environment.rb
    ''
  end
  
  module JavascriptHelpers
    def google_load(library, version, uncompressed = false)
      # just returns the basic javascript function
      %{google.load("#{library}","#{version}#{', {uncompressed:true}' if uncompressed}");}
    end
    def load_jsapi
      # also checks for and adds in your Google API key if provided
      %{<script src="http://www.google.com/jsapi#{"?key=" + google_api_key if google_api_key} type="text/javascript"></script>}
    end
    def js_wrapper(js_code)
      # HACK: there may be a built-in rails method that does this alreadys
      %{<script language="Javascript" type="text/javascript">#{js_code}</script>}
    end
    def guppi_load(*params)
      # find out if we want the compressed or uncompressed version of the js libs
      # if the uncompressed parameter hasn't been passed then !! will turn the nil into false
      uncompressed = !!params.delete(:uncompressed)
      
      # we won't load the jsapi first if you have this key in your param hash
      no_jsapi = !!params.delete(:no_jsapi)
      
      # we will assume the rest of the hash values are lib and version pairs
      js_libs_to_load = params.map{|lib,ver| google_load lib, ver, uncompressed}
      
      # HACK: gotta be a cleaner way to do this
      (no_jsapi ? [] : load_jsapi) + js_wrapper(lib_array.join('\n'))
    end
  end
  
  module JavascriptCache
    # FIXME: incomplete feature
    # this will download the javascript libs to your server, and then they can be loaded automatically if the libs online are unavailable
    # you will need to include the files you want to cache in your environment.rb
    
    def lib_url(library, version, uncompressed = false)
      # lets you easily generate the direct urls for libs
      "http://ajax.googleapis.com/ajax/libs/#{library}/#{version}/#{library}#{'.min' unless uncompressed}.js"
    end
  end
end
