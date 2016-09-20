## 3.2 / 2016-MM-DD

*   1 documentation change:

    *   Changed external documentation files to Markdown instead of Rdoc,
        except the README.

*   Code reorganization

    *   Renamed `lib/mime/types/{,default_}registry.rb`. Substantially improved
        the documentation of the default registry to include better examples.

## 3.1 / 2016-05-22

*   1 documentation change:

    *   Tim Smith ([@tas50](https://github.com/tas50)) updated the build badges
        to be SVGs to improve readability on high-density (retina) screens with
        pull request
        [#112](https://github.com/mime-types/ruby-mime-types/pull/112).

*   3 bug fixes

    *   A test for MIME::Types::Cache fails under Ruby 2.3 because of frozen
        strings,
        [#118](https://github.com/mime-types/ruby-mime-types/issues/118). This
        has been fixed.

    *   The JSON data has been incorrectly encoded since the release of
        mime-types 3 on the `xrefs` field, because of the switch to using a Set
        to store cross-reference information. This has been fixed.

    *   A tentative fix for
        [#117](https://github.com/mime-types/ruby-mime-types/issues/117) has
        been applied, removing the only circular require dependencies that
        exist (and for which there was code to prevent, but the current fix is
        simpler). I have no way to verify this fix and depending on how things
        are loaded by `delayed_job`, this fix may not be sufficient.

*   1 governance change

    *   Updated to [Contributor Covenant 1.4](Code-of-Conduct_md.html).

## 3.0 / 2015-11-21

*   2 governance changes

    *   This project and the related mime-types-data project are now
        exclusively MIT licensed. Resolves
        [#95](https://github.com/mime-types/ruby-mime-types/issues/95).

    *   All projects under the mime-types organization now have a standard code
        of conduct adapted from the [Contributor Covenant][]. This text can be
        found in the [Code-of-Conduct.md](Code-of-Conduct_md.html) file.

*   3 major changes

    *   All methods deprecated in mime-types 2.x have been removed.

    *   mime-types now requires Ruby 2.0 compatibility or later. Resolves
        [#97](https://github.com/mime-types/ruby-mime-types/issues/97).

    *   The registry data has been removed from mime-types and put into
        mime-types-data, maintained and released separately. It can be found at
        [mime-types-data][].

*   17 minor changes:

    *   MIME::Type changes:

        *   Changed the way that simplified types representations are creatd to
            reflect the fact that `x-` prefixes are no longer considered
            special according to IANA. A simplified MIME type is case-folded to
            lowercase. A new keyword parameter, `remove_x_prefix`, can be
            provided to remove `x-` prefixes.

        *   Improved initialization with an Array works so that extensions do
            not need to be wrapped in another array. This means that
            `%w(text/yaml yaml yml)` works in the same way that `['text/yaml',
            %w(yaml yml)]` did (and still does).

        *   Changed `priority_compare` to conform with attributes that no
            longer exist.

        *   Changed the internal implementation of extensions to use a frozen
            Set.

        *   When extensions are set or modified with `add_extensions`, the
            primary registry will be informed of a need to reindex extensions.
            Resolves
            [#84](https://github.com/mime-types/ruby-mime-types/issues/84).

        *   The preferred extension can be set explicitly. If not set, it will
            be the first extension. If the preferred extension is not in the
            extension list, it will be added.

        *   Improved how xref URLs are generated.

        *   Converted `obsolete`, `registered` and `signature` to
            attr_accessors.

    *   MIME::Types changes:

        *   Modified MIME::Types.new to track instances of MIME::Types so that
            they can be told to reindex the extensions as necessary.

        *   Removed `data_version` attribute.

        *   Changed #[] so that the `complete` and `registered` flags are
            keywords instead of a generic options parameter.

        *   Extracted the class methods to a separate file.

        *   Changed the container implementation to use a Set instead of an
            Array to prevent data duplication. Resolves
            [#79](https://github.com/mime-types/ruby-mime-types/issues/79).

    *   MIME::Types::Cache changes:

        *   Caching is now based on the data gem version instead of the
            mime-types version.

        *   Caching is compatible with columnar registry stores.

    * MIME::Types::Loader changes:

        *   MIME::Types::Loader::PATH has been removed and replaced with
            MIME::Types::Data::PATH from the mime-types-data gem. The
            environment variable `RUBY_MIME_TYPES_DATA` is still used.

        *   Support for the long-deprecated mime-types v1 format has been
            removed.

        *   The registry is default loaded from the columnar store by default.
            The internal format of the columnar store has changed; many of the
            boolean flags are now loaded from a single file. Resolves
            [#85](https://github.com/mime-types/ruby-mime-types/issues/85).

## 2.6.2 / 2015-09-13

*   Bugs:

    *   Emilio Losada ([@losadaem](https://github.com/losadaem)) fixed an error
        where `each_with_object`'s block parameters are the inverse of those
        used by `inject`. Resolves
        [#107](https://github.com/mime-types/ruby-mime-types/issues/107) with
        pull request
        [#108](https://github.com/mime-types/ruby-mime-types/pull/108).

    *   Matt Beedle ([@mattbeedle](https://github.com/mattbeedle)) fixed a typo
        in MIME::Type::Columnar negatively affecting people who use the
        `use_instead` functionality. Resolved in
        [#109](https://github.com/mime-types/ruby-mime-types/pull/109).

*   Documentation:

    *   Juanito Fatas ([@JuanitoFatas](https://github.com/JuanitoFatas)) fixed
        a documentation issue with the README not properly linking internally
        on the generated rdoc source. Resolved with
        [#105](https://github.com/mime-types/ruby-mime-types/pull/105).

*   Development:

    *   Fixed a minor issue in the IANA registry parser that would generate
        empty `text` xrefs if the `text` section was empty.

## 2.6.1 / 2015-05-25

*   Bugs:

    *   Make columnar store handle all supported extensions, not just the
        first. Resolved in
        [#103](https://github.com/mime-types/ruby-mime-types/pull/103) by
        Jeremy Evans ([@jeremyevans](https://github.com/jeremyevans)).

    *   Avoid circular require when using the columnar store. Resolved in
        [#102](https://github.com/mime-types/ruby-mime-types/pull/102) by
        Jeremy Evans.

## 2.6 / 2015-05-25

*   New Feature:

    *   Columnar data storage for the MIME::Types registry, contributed by
        Jeremy Evans ([@jeremyevans](https://github.com/jeremyevans)). Reduces
        default memory use
        substantially (the mail gem drops from 19 Mib to about 3 Mib). Resolves
        [#96](https://github.com/mime-types/ruby-mime-types/pull/96),
        [#94](https://github.com/mime-types/ruby-mime-types/issues/94),
        [#83](https://github.com/mime-types/ruby-mime-types/issues/83).
        Partially addresses
        [#64](https://github.com/mime-types/ruby-mime-types/issues/64) and
        [#62](https://github.com/mime-types/ruby-mime-types/issues/62).

*   Development:

    *   Removed caching of deprecation messages in preparation for mime-types
        3.0. Now, deprecated methods will always warn their deprecation instead
        of only warning once.

    *   Added a logger for deprecation messages.

    *   Renamed `lib/mime.rb` to `lib/mime/deprecations.rb` to not
        conflict with the [mime][] gem on behalf of the maintainers of the
        [Praxis Framework][]. Provided by Josep M. Blanquer
        ([@blanquer](https://github.com/blanquer)),
        [#100](https://github.com/mime-types/ruby-mime-types/pull/100).

    *   Added the columnar data conversion tool, also provided by Jeremy Evans.

*   Documentation:

    *   Improved documentation and ensured that all deprecated methods are
        marked as such in the documentation.

*   Development:

    *   Added more Ruby variants to Travis CI.

    *   Silenced deprecation messages for internal tools. Noisy deprecations
        are noisy, but that's the point.

## 2.5 / 2015-04-25

*   Bugs:

  *   David Genord ([@albus522](https://github.com/albus522)) fixed a bug in
      loading MIME::Types cache where a container loaded from cache did not
      have the expected `default_proc`,
      [#86](https://github.com/mime-types/ruby-mime-types/pull/86).

  *   Richard Schneeman ([@schneems](https://github.com/schneems)) provided a
      patch that substantially reduces unnecessary allocations.

*   Documentation:

    *   Tibor Szolár ([@flexik](https://github.com/flexik)) fixed a typo in the
        README, [#82](https://github.com/mime-types/ruby-mime-types/pull/82).

    *   Fixed [#80](https://github.com/mime-types/ruby-mime-types/issues/80),
        clarifying the relationship of MIME::Type#content_type and
        MIME::Type#simplified, with Ken Ip
        ([@kenips](https://github.com/kenips)).

*   Development:

  *   Juanito Fatas ([@JuanitoFatas](https://github.com/JuanitoFatas)) enabled
      container mode on Travis CI,
      [#87](https://github.com/mime-types/ruby-mime-types/pull/87).

  *   Moved development to a mime-types organization under
      [mime-types/ruby-mime-types][].

## 2.4.3 / 2014-10-21

*   Bugs:

    *   Restored Ruby 1.9.2 support by using `private_constant` conditionally.
        Fixes [#77](https://github.com/mime-types/ruby-mime-types/issues/77)
        found by Kris Leech ([@krisleech](https://github.com/krisleech)). The
        conditional use of `private_constant` here will be removed for
        mime-types 3.0, when Ruby 1.9.2 support will be unconditionally
        removed.

## 2.4.2 / 2014-10-15

*   Bugs:

    *   Aaron Patterson ([@tenderlove](https://github.com/tenderlove)) found a
        loading bug and provided a fix that nearly doubled registry load
        performance
        ([#74](https://github.com/mime-types/ruby-mime-types/pull/74)).
    *   Godfrey Chan ([@chancancode](https://github.com/chancancode)) provided
        a prophylactic security fix to use `JSON.parse` instead of `JSON.load`
        in [#75](https://github.com/mime-types/ruby-mime-types/pull/75). This
        provides a 20% improvement over the already improved result, resulting
        in a total 55% performance boost.

## 2.4.1 / 2014-10-07

mime-types 2.4 was pulled.

*   Bugs:

    *   Restored the extension sort order from mime-types 1.25.1 and modified
        MIME::Type#extensions= to no longer sort extensions when set. This
        resolves [#71](https://github.com/mime-types/ruby-mime-types/issues/71)
        and should fix Paperclip.

*   API Changes:

    *   Added MIME::Type#preferred_extension to return the preferred extension
        for the MIME type. This should be used in preference to the current
        mechanism used by many clients, `type.extensions.first`. This will
        allow the implementation to change over time.

    *   Added MIME::Type#friendly based on the concept presented by Łukasz Ś
        liwa’s [friendly_mime][] gem. The initial English data for this is
        pulled from `friendly_mime`.

    *   Added MIME::Type#i18n_key and MIME::Type.i18n_key to represent and
        convert MIME content types as translation keys for the I18n library.

*   MIME Type Development Tools:

    *   Adding documentation to conversion methods.

    *   Adding some robustness to missing Nokogiri support.

    *   Extending coverage to fully cover new code. Tests now cover all of
        mime-types.

## 2.3 / 2014-05-23

*   Bugs:

    *   Fixed a bug in <tt>MIME::Types#type_for</tt> where type specifications
        that did not match a MIME::Type would be returned as `nil` inside the
        returned array. This was incorrect behaviour as those values should not
        have been returned, resulting in an empty array.

*   MIME Type Development Tools:

    *   As always, there are bugs in the IANA registry because it's manually
        maintained. Some robustness has been added to properly writing file
        template references where the file template reference is not a full
        media type specification (e.g., 'amr-wb+' instead of
        'audio/amr-wb+').

    *   Both the IANA and Apache import tools were unnecessarily case-sensitive
        in matching against already-existing MIME types, resulting in extra
        work to weed out duplicates that differed only in the case of the
        canonical content type. This has been fixed.

## 2.2 / 2014-03-14

*   Clarified contribution guidelines for MIME types. Resolves
    [#57](https://github.com/mime-types/ruby-mime-types/issues/57).

*   Fixed a small bug where deprecated methods would warn of deprecation when
    called by internal methods. Resolves
    [#60](https://github.com/mime-types/ruby-mime-types/issues/60).

*   Dropped Code Climate; added Coveralls for test coverage reports.

*   Removing external references to RubyForge, as it is shutting down. Resolves
    [#59](https://github.com/mime-types/ruby-mime-types/issues/59).

## 2.1 / 2014-01-25

*   API Changes (MIME::Type):

    *   Added MIME::Type#xrefs and MIME::Type#xref_urls that have better
        handling of types of reference information. MIME::Type#references= has
        been deprecated. In a future release, both MIME::Type#references will
        be turned into a short-hand view on MIME::Type#xrefs, MIME::Type#urls
        will be an alias for MIME::Type#xref_urls, and MIME::Type#references=
        will be removed.

*   New or Updated MIME Types:

    *   This information is now tracked in [mime-types-data/History-Types.md][].

*   MIME Type Development Tools:

    *   The IANA registry format changed, breaking the IANA registry tool
        previously used. Rewrote IANADownloader and IANADownloader::Parser as
        IANARegistryParser using the XML form.

    *   The LTSW list has been dropped as it has not been updated since 2002.

    *   The default Apache MIME types configuration list is now used to enrich
        MIME type data with additional extension information.

## 2.0 / 2013-10-27

*   API Changes (General):

    *   mime-types is no longer compatible with Ruby 1.8. Additionally, for its
        YAML operations (normally development and test), it requires a YAML
        parser that conforms to the Psych parser, not the Syck parser. This
        would only be a problem with an alternative Ruby 1.9.2 interpreter that
        does not implement the Psych parser conventions by requiring `psych`.

    *   MIME::InvalidContentType has been renamed to
        MIME::Type::InvalidContentType.

*   API Changes (MIME::Type):

    *   Construction of a MIME::Type can be with any of the following objects:

        *   An array containing a valid content type identifier and an optional
            array of extensions. This allows MIME::Type.new to be used instead
            of MIME::Type.from_array for the most common use-case. Fixes
            [#43](https://github.com/mime-types/ruby-mime-types/pull/43).

        *   A Hash containing the output of MIME::Type#to_h, as would be
            deserialized from the JSON representation of a MIME::Type. This
            replaces MIME::Type.from_hash using a different parameter set.

        *   Another MIME::Type.

        *   A content type identifier string.

    *   Assignment of an invalid encoding to MIME::Type#encoding= will raise a
        MIME::Type::InvalidEncoding exception rather than a plain
        ArgumentError.

    *   MIME::Type#url has been renamed to MIME::Type#references.

    *   MIME::Type#use_instead is now tracked as its own attribute, not as part
        of MIME::Type#docs.

    *   MIME::Type#system, MIME::Type#system?, MIME::Type#platform?,
        MIME::Type#to_a, MIME::Type#to_hash, MIME::Type.from_array,
        MIME::Type.from_hash, and MIME::Type.from_mime_type have been
        deprecated for removal.

    *   Implemented YAML object encoding and decoding methods,
        MIME::Type#encode_with and MIME::Type#init_with.

    *   Implemented JSON hash encoding methods.

    *   Added MIME::Type#add_extensions to easily add extensions to a
        MIME::Type. Fixes
        [#44](https://github.com/mime-types/ruby-mime-types/pull/44).

*   API Changes (MIME::Types):

    *   MIME type caching has been extracted to its own class. It is
        structurally similar to what was introduced with mime-types 1.25, but
        is no longer considered an experimental interface.

    *   MIME type loading has been extracted to its own class. Loading has
        changed substantially.

    *   MIME::Types#[] accepts a new filter flag, :registered. The :platform
        flag has been deprecated.

    *   The MIME::Types#type_for platform parameter has been deprecated.

    *   Added the ability for MIME::Types#type_for produce results for multiple
        filenames or extensions by providing an array as the first parameter.
        Fixes [#42](https://github.com/mime-types/ruby-mime-types/pull/42).

    *   MIME::Types#add_type_variant and MIME::Types#index_extensions have been
        deprecated as public methods. They will be private in a future version.

    *   MIME::Types#defined_types, MIME::Types.cache_file,
        MIME::Types.add_type_variant, and MIME::Types.index_extensions have
        been deprecated for removal.

*   Default Registry Changes:

    *   The default registry is now a file in the directory data/, located via
        MIME::Types::Loader::PATH. `PATH` is defined in the file
        lib/mime/types/path.rb so that system packagers only have to modify one
        file in order to put the registry in a location that is not where a gem
        version of mime-types would expect it. This resolves issue
        [#36](https://github.com/mime-types/ruby-mime-types/pull/36), reported
        by [@postmodern](https://github.com/postmodern).

    *   The default registry is now a single file in JSON format. This resolves
        issue [#28](https://github.com/mime-types/ruby-mime-types/pull/28)
        reported by [@jasonlor](https://github.com/jasonlor) (an error with
        mime-types in MacRuby).

    *   The default registry is compiled from YAML files in type-lists/,
        resolving issue
        [#37](https://github.com/mime-types/ruby-mime-types/pull/37) reported
        by @postmodern requesting an easier-to-edit format.

*   MIME Type Development Tools:

    *   The benchmarking task has been moved mostly to support/benchmarker.rb.

    *   A task for SimpleCov coverage has been added (`rake test:coverage`).

    *   IANA type registry downloading has been substantially improved and the
        implementation no longer resides in the Rakefile; it has instead been
        moved to support/iana_downloader.rb. This takes advantage of the new
        YAML encoding functionality to update added or modified MIME types
        non-destructively in `type-lists/` by default.

    *   Rake tasks `convert:yaml:json` and `convert:json:yaml` provide
        functionality to convert the human-editable YAML format in
        `type-lists/` to the JSON format in `data/` and vice-versa. This is
        powered by support/convert.rb.

## 1.25 / 2013-08-30

*   New Features:

  *   Adding lazy loading and caching functionality to the default data based
      on work done by Greg Brockman ([@gdb](https://github.com/gdb)).

*   Bugs:

  *   Force the default internal application encoding to be used when reading
      the MIME types database. Based on a change by
      [@briangamble](https://github.com/briangamble), found in the rapid7 fork.

*   Modernized Minitest configuration.

## 1.24 / 2013-08-14

*   Code Climate:

    *   Working on improving the quality of the mime-types codebase through the
        use of Code Climate.

    *   Simplified MIME::Type.from_array to make more assumptions about
        assignment.

*   Documentation:

    *   Leo Young pointed out that the README contained examples that could
        never possibly work because MIME::Types#[] returns (for all the
        versions I have handy) an array, not a single type. I have updated the
        README to reflect this.

    *   Removed Nokogiri as a declared development dependency. It is still
        required if you're going to use the IANA parser functionality, but it
        is not necessary for most development purposes. This has been removed
        to ensure that Travis CI passes on Ruby 1.8.7.

## 1.23 / 2013-04-20

*   New Feature:

    *   Arnaud Meuret ([@ameuret](https://github.com/ameuret)) suggested that
        it could be useful if the MIME type collection was enumerable, so he
        implemented it in
        [#30](https://github.com/mime-types/ruby-mime-types/pull/30). Thanks
        for the contribution!

*   Administrivia:

    *   The gemspec now includes information about the licenses under which the
        mime-types gem is available.

    *   Using hoe-gemspec2 instead of hoe-gemspec.

## 1.22 / 2013-03-30

*   Added support for Ruby 2.0 with Travis CI.

## 1.21 / 2013-02-09

*   Fixed some Manifest related madness on Travis.

## 1.20.1 / 2013-01-26

*   Enabled for use with travis.

*   Enabled gem signing.

*   Fixed an error related to MIME type downloads.

*   This was previously published as 1.20, but I had forgotten some
    attributions.

## 1.19 / 2012-06-20

*   Resolved [#8](https://github.com/mime-types/ruby-mime-types/issues/8).
    Apparently some people run the tests on Linux. Imagine that.

## 1.18 / 2012-03-20

*   Bug Fixes:

    *   It was pointed out that Licence.txt was incorrectly named. Fixed by
        renaming to Licence.rdoc (from
        [#8](https://github.com/mime-types/ruby-mime-types/issues/8)).

    *   It was pointed out that a plan to have the test output generated
        automatically never went through.
        [#10](https://github.com/mime-types/ruby-mime-types/issues/10)

## 1.17.2 / 2011-10-25

*   Bug Fixes:

  *   Fixed an issue with Ruby 1.9 and file encoding.

## 1.17.1 / 2011-10-23

*   Minor Enhancements:

    *   Implemented modern 'hoe' semantics.

    *   Switched to minitest instead of test/unit.

    *   Converted documentation from .txt to .rdoc.

    *   Removed setup.rb.
        [#3](https://github.com/mime-types/ruby-mime-types/issues/3).

    *   Should no longer complain about missing RubyGems keys
        [#2](https://github.com/mime-types/ruby-mime-types/issues/2).

    *   Made it much easier to update MIME types from this point forward.

    *   Updated MIME types from IANA.

## 1.16

*   Made compatible with Ruby 1.8.6, 1.8.7, and 1.9.1.

*   Switched to the 'hoe' gem system and added a lot of build-time tools.

*   Updated the MIME types to the list based on the values in the Perl library
    version 1.27. Also updated based on external source information and bug
    reports.

*   This is the last planned version of MIME::Types 1.x. Work will be
    starting soon on MIME::Types 2.x with richer data querying mechanisms and
    support for external data sources.

## 1.15

*   Removed lib/mime/type.rb to form a single MIME::Types database source. It
    is unlikely that one will ever need MIME::Type without MIME::Types.
*   Re-synchronized the MIME type list with the sources, focusing primarily on
    the IANA list.
*   Added more detailed source information for MIME::Type objects.
*   Changed MIME::Types from a module to a class with a default instance. There
    should be no difference in usage.
*   Removed MIME::Types::DATA_VERSION; it is now an attribute on the
    MIME::Types instance.
*   NOTE: Synchronization with the Perl version of MIME::Types is no longer a
    priority as of this release. The data format and information has changed.
*   Removed MIME::Types.by_suffix and MIME::Types.by_mediatype.

## 1.13.1

*   Fixed a problem with the installer running tests. This now works.
*   Improved the implementation of MIME::Type.signature?
*   Moved code around to use the `class << self` idiom instead of always
    prepending the module/class name.
*   Added two new best-guess implementations of functions found in Perl's
    MIME::Types implementation (1.13). Do not rely on these until the purpose
    and implementation is stabilised.
*   Updated the MIME list to reflect changes noted by Ville Skyttä.
*   Added a new constant to MIME::Types, DATA_VERSION. This will allow the Ruby
    version number to be updated separately from the Perl version while keeping
    the MIME Type list version in sync.

## 1.13

> WARNING: This version changes the API of MIME::Types and is compatible with
> Ruby 1.8 and higher ONLY.

*   Removed dependency on InstallPackage; offering 1.13 as either .tar.gz or
    .gem.

*   Split into two files, mime/type.rb and mime/types.rb. This will make
    maintaining the list of changes easier.

*   Changed the MIME::Type construction API. Accepts only a single String
    argument (but does no named type-checking) and yields self.

*   Removed private methods #init_extensions, #init_encoding, and #init_system
    and replaced with #extensions=, #encoding=, and #system=.

*   Added #default_encoding to return 'quoted-printable' or 'base64' depending
    on the media type of the MIME type.

*   Added #raw_media_type and #raw_sub_type to provide the non-simplified
    versions of the media type and subtype.

*   Alternative constructors MIME::Type.from_array, MIME::Type.from_hash, and
    MIME::Type.from_mime_type added to compensate for the removal of named type
    checking in the original constructor.

*   Added #to_str, #to_a, and #to_hash methods. The latter two will provide
    output suitable for use in #from_array and #from_hash.

*   Removed "binary" encoding and enforced the use of a valid encoding string.

*   Added #system? returning true if the MIME::Type is an OS-specific
    MIME::Type.

*   Added #platform? returning true if the MIME::Type is an OS-specific
    MIME::Type for the current RUBY_PLATFORM.

*   Added #like? returning true if the simplified type matches the other value
    provided. #<'application/x-excel'>.like?('application/excel') is true.

*   Added #complete? returning true if the MIME::Type specifies an extension
    list.

*   Updated the MIME type list to reflect additions by Mark Overmeer for Perl's
    MIME::Types 1.12 and the official IANA list as of 2004.04.06. A number of
    formerly "registered" MIME types are now no longer registered (e.g.,
    application/excel is now application/x-excel). This ensures that the
    simplified type still works with applications, but does not report an
    unregistered type as registered.

*   Restored MIME type list to Mark Overmeer's format to facilitate easy
    exchange between the two projects.

*   Added additional unit tests from Mark Overmeer's 1.12 version.

## 1.07

*   Changed version numbering to match Perl MIME::Types 1.07.

*   Re-synchronized with Mark Overmeer's list in Perl PMIME::Types 1.07.

*   NN Poster updated the attributes for the PGP types.

## 1.005

*   Changed to Phil Thomson's InstallPackage.

*   Added several types from Perl MIME::Types 1.005.

*   Cleaned up data format; some data formats will show up with proper data
    now.

## 1.004

*   Updated to match Perl MIME::Types 1.004, links credited to Dan Puro. Adds
    new reference list to http://www.indiana.edu/cgi-bin-local/mimetypes

*   Removed InvalidType and replaced with TypeError.

*   Changed instances of #type to #class.

*   Cleaned up how simplified versions are created.

## 1.003

*   Initial release based on Perl MIME::Types 1.003.

[Contributor Covenant]: http://contributor-covenant.org
[mime-types-data]: https://github.com/mime-types/mime-types-data
[mime]: https://rubygems.org/gems/mime
[Praxis Framework]: http://praxis-framework.io/
[mime-types/ruby-mime-types]: https://github.com/mime-types/ruby-mime-types
[friendly_mime]: https://github.com/lukaszsliwa/friendly_mime
[mime-types-data/History-Types.md]: https://github.com/mime-types/mime-types-data/blob/master/History.md