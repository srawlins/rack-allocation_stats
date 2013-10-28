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
    expect(abbreviateClass("Arel::Attributes::Attribute")).toBe("Arel::&hellip;::Attribute");
    expect(abbreviateClass("ActionDispatch::Routing::RouteSet::Generator")).toBe("ActionDispatch::&hellip;::Generator");
  });

  it("abbreviates subclasses when >= 3 namespaces", function() {
    expect(abbreviateClass("Array<String>")).toBe("Array<String>");
    expect(abbreviateClass("Array<Fixnum,String>")).toBe("Array<Fixnum,String>");
    expect(abbreviateClass("Array<Arel::Nodes::Equality>")).toBe("Array<Arel::&hellip;::Equality>");
  });
});

describe("getParameterByName", function() {
  it("retuns blank if parameter not present", function() {
    var location = { search: "?a=b" };
    expect(getParameterByName("c")).toBe("");
  });

  it("retuns parameters by name when one parameter is present", function() {
    var location = { search: "?a=b" };
    expect(getParameterByName("a")).toBe("b");

    location = { search: "?a[b]=c" };
    expect(getParameterByName("a[b]")).toBe("c");
    expect(getParameterByName("a[c]")).toBe("");
    expect(getParameterByName("a")).toBe("");
  });

  it("retuns parameters by name when multiple parameters are present", function() {
    var location = { search: "?a=b&c=d" };
    expect(getParameterByName("a")).toBe("b");
    expect(getParameterByName("c")).toBe("d");

    location = { search: "?a[b]=c&a[d]=e" };
    expect(getParameterByName("a[b]")).toBe("c");
    expect(getParameterByName("a[d]")).toBe("e");
    expect(getParameterByName("a[e]")).toBe("");
  });
});
