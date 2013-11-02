/* Copyright 2013 Google Inc. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0, found in the LICENSE file.
 */

/**
 * Rack AllocationStats is...
 */

/**
 * ## abbreviateClass()
 *
 * `abbreviateClass()` is a method that abbreviates the inside namespaces of a
 * long Ruby class name. Examples:
 *
 * Array => Array
 * Arel::Attributes::Attribute => Arel::...::Attribute
 */
describe("abbreviateClass", function() {
  it("leaves classes with < 3 namespaces alone", function() {
    expect(abbreviateClass("Array")).toBe("Array");
    expect(abbreviateClass("File::Stat")).toBe("File::Stat");
  });

  it("abbreviates classes with > 3 namespaces", function() {
    expect(abbreviateClass("Arel::Attributes::Attribute")).
      toBe('<abbr title="Arel::Attributes::Attribute">Arel::Att&hellip;Attribute</abbr>');
    expect(abbreviateClass("ActionDispatch::Routing::RouteSet::Generator")).
      toBe('<abbr title="ActionDispatch::Routing::RouteSet::Generator">ActionDispatch::Rou&hellip;Generator</abbr>');
  });

  it("abbreviates subclasses when >= 3 namespaces", function() {
    expect(abbreviateClass("Array<String>")).toBe("Array<String>");
    expect(abbreviateClass("Array<Fixnum,String>")).toBe("Array<Fixnum,String>");
    expect(abbreviateClass("Array<Arel::Nodes::Equality>")).
      toBe('<abbr title="Array<Arel::Nodes::Equality>">Array<Arel::Nod&hellip;Equality></abbr>');
  });

  it("doesn't abbreviate when only 3 namespaces and middle has < 5 letters", function() {
    expect(abbreviateClass("ActionDispatch::Http::ParameterFilter")).toBe("ActionDispatch::Http::ParameterFilter");
  });
});

/**
 * ## getParameterByName()
 *
 * `getParameterByName()` is a method that grabs a URL parameter from
 * location.search by name. It's amazing this isn't directly available.
 */
describe("getParameterByName", function() {
  it("returns blank if parameter not present", function() {
    spyOn(util, "locationSearch").andReturn("?a[b]=c");
    expect(getParameterByName("c")).toBe("");
  });

  it("returns parameters by name when one parameter is present", function() {
    spyOn(util, "locationSearch").andReturn("?a=b");
    expect(getParameterByName("a")).toBe("b");
  });

  it("returns parameters by name when one bracketed parameter is present", function() {
    spyOn(util, "locationSearch").andReturn("?a[b]=c");
    expect(getParameterByName("a[b]")).toBe("c");
    expect(getParameterByName("a[c]")).toBe("");
    expect(getParameterByName("a")).toBe("");
  });

  it("returns parameters by name when multiple parameters are present", function() {
    spyOn(util, "locationSearch").andReturn("?a=b&c=d");
    expect(getParameterByName("a")).toBe("b");
    expect(getParameterByName("c")).toBe("d");
  });

  it("returns parameters by name when multiple bracketed parameters are present", function() {
    spyOn(util, "locationSearch").andReturn("?a[b]=c&a[d]=e");
    expect(getParameterByName("a[b]")).toBe("c");
    expect(getParameterByName("a[d]")).toBe("e");
    expect(getParameterByName("a[e]")).toBe("");
  });
});

describe("filterOutPwd", function() {
  it("filters out allocations with a sourcefile in PWD", function() {
    var a1 = { class: 'Thread::ConditionVariable',
                 file: '<RUBYLIBDIR>/monitor.rb' },
        a2 = { class: 'ActionView::CompiledTemplates',
               file: '<PWD>/app/views/projects/index.html.erb' },
        allocations = [ a1, a2 ],
        filtered  = filterOutPwd(allocations);

    expect(filtered).toEqual([a1]);
  });
});

describe("filterOutRuby", function() {
  it("filters out allocations with a sourcefile in RUBYLIBDIR", function() {
    var a1 = { class: 'Thread::ConditionVariable',
                 file: '<RUBYLIBDIR>/monitor.rb' },
        a2 = { class: 'ActionView::CompiledTemplates',
               file: '<PWD>/app/views/projects/index.html.erb' },
        allocations = [ a1, a2 ],
        filtered  = filterOutRuby(allocations);

    expect(filtered).toEqual([a2]);
  });
});

/**
 * Copyright 2013 Google Inc. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0, found in the LICENSE file.
 */
