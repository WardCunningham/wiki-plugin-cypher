expand = (text)->
  text
    .replace /.[\b](.)/g, '$1'
    .replace /&/g, '&amp;'
    .replace /</g, '&lt;'
    .replace />/g, '&gt;'
    .replace /\n/g, '<br>'

emit = ($item, item) ->
  $item.append """
    <div style="background-color:#eee;padding:15px;">
      <p> #{expand item.text} <button style="float:right;">run</button> </p>
    </div>
  """

parse = (text) ->
  sites = []
  slugs = []
  for line in text.trim().split /\n/
    if /\./.test line
      sites.push line.trim()
    else
      slugs.push line.trim()
  {sites, slugs}

format = (results) ->
  return "<p class='error'>no pages found</p>" unless results?.data?.length > 0
  p = results.columns.indexOf 'page.title'
  s = results.columns.indexOf 'site.title'
  l = results.columns.indexOf 'link.title'
  pages = {}
  for r in results.data
    pages[r.row[p]] ||= {}
    pages[r.row[p]][r.row[s]] = true
  html = []
  for slug, sites of pages
    html.push "<span>#{slug}</span><br>"
    for site, mark of sites
      html.push """
        <img
          title=#{site}
          src='http://#{site}/favicon.png'
          data-site='#{site}'
          data-slug='#{slug}'
          class='remote'>
      """
    html.push "<br>"
  "<div>#{html.join("\n")}</div>"



bind = ($item, item) ->
  $item.dblclick -> wiki.textEditor $item, item
  json = (string) ->
    JSON.stringify (JSON.parse string), null, '  '
  report = (reply) ->
    $item.find('div').append """
      <div class="reply" style="background-color:#fff; padding: 10px;">
        #{format reply.results[0]}
      </div>
    """
        # <pre style='font-size: 10px; word-wrap: break-word; color: #d00'>#{expand reply.stderr}</pre>
        # <pre style='font-size: 10px; word-wrap: break-word;'>#{expand json reply.stdout}</pre>

  $item.find('button').click ->
    $item.find('.reply').remove()
    # $.post '/plugin/cypher', item, report
    $.ajax
      type: 'POST'
      url: '/plugin/cypher/'
      data: JSON.stringify (parse item.text)
      success: report
      contentType: "application/json"
      dataType: 'json'


window.plugins.cypher = {emit, bind} if window?
module.exports = {expand} if module?

