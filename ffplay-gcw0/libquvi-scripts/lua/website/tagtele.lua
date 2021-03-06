
-- libquvi-scripts v0.4.21
-- Copyright (C) 2012,2013  Toni Gundogdu <legatvs@gmail.com>
-- Copyright (C) 2010  Paul Kocialkowski <contact@paulk.fr>
--
-- This file is part of libquvi-scripts <http://quvi.sourceforge.net/>.
--
-- This library is free software; you can redistribute it and/or
-- modify it under the terms of the GNU Lesser General Public
-- License as published by the Free Software Foundation; either
-- version 2.1 of the License, or (at your option) any later version.
--
-- This library is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
-- Lesser General Public License for more details.
--
-- You should have received a copy of the GNU Lesser General Public
-- License along with this library; if not, write to the Free Software
-- Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
-- 02110-1301  USA
--

-- Identify the script.
function ident(self)
    package.path = self.script_dir .. '/?.lua'
    local C      = require 'quvi/const'
    local r      = {}
    r.domain     = "tagtele%.com"
    r.formats    = "default"
    r.categories = C.proto_http
    local U      = require 'quvi/util'
    r.handles    = U.handles(self.page_url, {r.domain}, {"/videos/voir/%d+"})
    return r
end

-- Query available formats.
function query_formats(self)
    self.formats = 'default'
    return self
end

-- Parse media URL.
function parse(self)
    self.host_id = "tagtele"

    local p = quvi.fetch(self.page_url)

    self.title = p:match('meta name="title" content="(.-)"')
                  or p:match('meta property="og:title" content="(.-)"')
                    or error("no match: media title")

    self.id = self.page_url:match('/voir/(%d+)')
                or error("no match: media ID")

    self.thumbnail_url = p:match('og:image" content="(.-)"') or ''

    local pl_url = "http://www.tagtele.com/videos/playlist/"..self.id.."/"
    local pl = quvi.fetch(pl_url, {fetch_type='playlist'})

    self.url = {pl:match("<location>(.-)</")
                  or error("no match: media URL")}

    return self
end

-- vim: set ts=4 sw=4 tw=72 expandtab:
