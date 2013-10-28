/* Copyright 2013 Google Inc. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0, found in the LICENSE file.
 */

function byFileLineAndClassPlus(allocation) {
  return JSON.stringify([allocation["file"], allocation["line"], allocation["class_plus"]]);
}

function fillClassAbbreviations() {
  _.each(allocations, function(a) {
    if (classAbbreviations[a["class_plus"]]) { return; }

    if (a["class_plus"] !== null) {
      var klass = a["class_plus"],
          match = /^([^<]+)(<(.+)>)?/.exec(klass),
          outerAbbreviation = abbreviateClass(match[1]),
          innerAbbreviations = _.map((match[3] || "").split(/,/), abbreviateClass);

      classAbbreviations[klass] = outerAbbreviation +
        (match[3] ? "<" + innerAbbreviations.join(",") +  ">" : "");
    }

    if (classAbbreviations[a["class"]]) { return; }
    if (a["class"] === null) { return; }
    classAbbreviations[a["class"]] = abbreviateClass(a["class"]);
  });
}

function abbreviateClass(c) {
  var n = c.split(/::/);
  if (n.length < 3) { return c; };
  return n[0] + "::&hellip;::" + n[n.length-1];
}

function fillTableWith(groups, headers) {
  /* table headers */
  var headTr = $("<tr/>"),
      fileColonLineIndex = null,
      lineIndex = null,
      classPathSpaceMethodIdIndex = null,
      methodIdIndex = null,
      classAbbreviationIndex = null;

  if (groups.length === 0) {
    $("#allocations thead").empty();
    $("#allocations tbody").empty();
    $("#allocations-row-count").text("0 rows");
    if (allocations.length > 0) {
      $("#allocations-row-count").text(
          "0 rows (all of the original " +
          allocations.length +
          " allocations have been filtered out.)");
    }
    return;
  }

  for (i in headers) {
    /* i is not an integer; the first i plus 1 is "01" */
    if (headers[i] === "file" && headers[i*1 + 1] === "line") {
      fileColonLineIndex = i;
      headers[i] = "file:line";
    }

    if (fileColonLineIndex && headers[i] === "line") {
      lineIndex = i;
      continue;
    }

    /* i is not an integer; the first i plus 1 is "01" */
    if (headers[i] === "class_path" && headers[i*1 + 1] === "method_id") {
      classPathSpaceMethodIdIndex = i;
      headers[i] = "class_path method_id";
    }

    if (classPathSpaceMethodIdIndex && headers[i] === "method_id") {
      methodIdIndex = i;
      continue;
    }

    if (headers[i].indexOf(" (abbrev)") >= 0) {
      classAbbreviationIndex = i;
    }

    headTr.append("<th>" + headers[i] + "</th>");
  }

  if (lineIndex)     { headers.splice(lineIndex, 1); }
  if (methodIdIndex) { headers.splice(methodIdIndex, 1); }

  headTr.append("<th>count</th>");
  $("#allocations thead").html(headTr);
  $("#allocations tbody").empty();
  var totalCount = 0;

  var showPercent = true;
  for (var tuple in groups) {
    var key    = groups[tuple][0];
    var allocs = groups[tuple][1];
    var tr = $("<tr/>");
    keys = eval(key); /* unstringify */
    for (var i in keys) {
      if (fileColonLineIndex          && i === lineIndex)     { continue; }
      if (classPathSpaceMethodIdIndex && i === methodIdIndex) { continue; }

      if (i === fileColonLineIndex) {
        tr.append($("<td>").text(keys[i] + ":" + keys[lineIndex]));
      } else if (i === classPathSpaceMethodIdIndex) {
        var class_path_html = '<span class="nc">' + keys[i] + '</span>';
        var method_id_html  = '<span class="nf">' + keys[methodIdIndex] + '</span>';
        tr.append($("<td>").html(class_path_html + " " + method_id_html));
      } else if (i === classAbbreviationIndex) {
        tr.append($("<td>").html(classAbbreviations[keys[i]]));
      } else {
        tr.append($("<td>").text(keys[i]));
      }
    }

    count = allocs.length;
    totalCount += count;
    if (showPercent) {
      pct = (count/allocations.length*100).toFixed(2);
      if (pct < 10) { pct = " " + pct; }
      tr.append($("<td>").addClass("count").text(count + " (" + pct + "%)"));
    } else {
      tr.append($("<td>").addClass("count").text(count));
    }

    $("#allocations tbody").append(tr);
  }

  if (showPercent) {
    pct = (totalCount/allocations.length*100).toFixed(2);
    if (pct < 10) { pct = " " + pct; }
  }
  $("<tr/>").
      addClass("footer").
      addClass("total").
      append('<td class="count" colspan="' + headers.length + '">total count</td>').
      append('<td class="count">' + totalCount + " (" + pct + "%)" + "</td>").
      appendTo($("#allocations tbody"));

  var filtered = allocations.length - totalCount;
  $("<tr/>").
      addClass("footer").
      append('<td class="count" colspan="' + (headers.length+1) + '">(' + filtered + ' more have been filtered out)</td>').
      appendTo($("#allocations tbody"));

  $("#allocations-row-count").text(groups.length + " rows");
}

function filterOutPwd(filtered) {
 return $.grep(filtered, function(a) {
   var r = new RegExp(pwd);
   return r.exec(a["file"]) === null;
 });
}

function filterOutRuby(filtered) {
 return $.grep(filtered, function(a) {
   var r = new RegExp("<RUBYLIBDIR>");
   return r.exec(a["file"]) === null;
 });
}

function filterOutGems(filtered) {
 return $.grep(filtered, function(a) {
   var r = new RegExp("<GEMDIR>");
   return r.exec(a["file"]) === null;
 });
}

function filterOutEval(filtered) {
 return $.grep(filtered, function(a) {
   return a["file"] !== "(eval)";
 });
}

function filterAllocationsByControls() {
  var filtered = allocations;
  if ($("#filter-pwd")[0].checked) {
    filtered = filterOutPwd(filtered);
  }

  if ($("#filter-ruby")[0].checked) {
    filtered = filterOutRuby(filtered);
  }

  if ($("#filter-gems")[0].checked) {
    filtered = filterOutGems(filtered);
  }

  if ($("#filter-eval")[0].checked) {
    filtered = filterOutEval(filtered);
  }

  return filtered;
}

function getParameterByName(name) {
    name = name.replace(/[\[]/, "\\\[").replace(/[\]]/, "\\\]");
    var regex = new RegExp("[\\?&]" + name + "=([^&#]*)"),
        results = regex.exec(util.locationSearch());
    return results == null ? "" : decodeURIComponent(results[1].replace(/\+/g, " "));
}

function groupByFields(list, fields) {
  return _.groupBy(list, function(allocation) {
    values = new Array();

    for (i in fields) {
      values.push(allocation[fields[i]]);
    }
    return JSON.stringify(values);
  });
}

var util  = (function() {
  function locationSearch() {
    return location.search;
  }

  return {
    locationSearch: locationSearch
  };
})();

function minCount(allocations) {
  return allocations.length >= $("#filter-count").val();
}

function refillTable(e) {
  // Filter stuff
  var filtered = filterAllocationsByControls(),
  // Group stuff by other stuff
      gbInputs = $("#gb-controls").find("input"),
      abbreviateClassesInput = $("input#option-abbreviate-classes")[0],
      headers = new Array(),
      fields = new Array();

  $.each(gbInputs, function(idx, gbInput) {
    if (gbInput.checked) {
      var field = gbInput.getAttribute("name");
      fields.push(field);

      if (field === "class") {
        abbreviateClassesInput.checked ? headers.push("class (abbrev)") : headers.push("class");
      } else if (field === "class_plus") {
        abbreviateClassesInput.checked ? headers.push("class+ (abbrev)") : headers.push("class+");
      } else {
        headers.push(field);
      }
    }
  });

  fillTableWith(_.sortBy(tupleize(groupByFields(filtered, fields), minCount), valueLength), headers);
}

function tupleize(object, filter) {
  tuples = [];
  for (var key in object) {
    if (! minCount(object[key])) { continue; }
    tuples.push([key, object[key]]);
  }

  return tuples;
}

function valueLength(tuple) {
  return - tuple[1].length; /* descending */
}
