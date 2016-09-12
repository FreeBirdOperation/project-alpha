//
//  ResponseInjections.swift
//  Chowroulette
//
//  Created by Daniel Seitz on 7/29/16.
//  Copyright © 2016 Daniel Seitz. All rights reserved.
//

import Foundation

class ResponseInjections {
  
  static let yelpErrorResponse = "ew0KICAgICJlcnJvciI6IHsNCiAgICAgICAgInRleHQiOiAiSW52YWxpZCBwYXJhbWV0ZXIiLA0KICAgICAgICAiaWQiOiAiSU5WQUxJRF9QQVJBTUVURVIiLA0KICAgICAgICAiZmllbGQiOiAibG9jYXRpb24iDQogICAgfQ0KfQ=="
  
  static let yelpValidOneBusinessResponse = "ew0KICAgICJidXNpbmVzc2VzIjogWw0KICAgICAgICB7DQogICAgICAgICAgICAiY2F0ZWdvcmllcyI6IFsNCiAgICAgICAgICAgICAgICBbDQogICAgICAgICAgICAgICAgICAgICJMb2NhbCBGbGF2b3IiLA0KICAgICAgICAgICAgICAgICAgICAibG9jYWxmbGF2b3IiDQogICAgICAgICAgICAgICAgXSwNCiAgICAgICAgICAgICAgICBbDQogICAgICAgICAgICAgICAgICAgICJNYXNzIE1lZGlhIiwNCiAgICAgICAgICAgICAgICAgICAgIm1hc3NtZWRpYSINCiAgICAgICAgICAgICAgICBdDQogICAgICAgICAgICBdLA0KICAgICAgICAgICAgImRpc3BsYXlfcGhvbmUiOiAiKzEtNDE1LTkwOC0zODAxIiwNCiAgICAgICAgICAgICJpZCI6ICJ5ZWxwLXNhbi1mcmFuY2lzY28iLA0KICAgICAgICAgICAgImltYWdlX3VybCI6ICJodHRwOi8vczMtbWVkaWEzLmZsLnllbHBjZG4uY29tL2JwaG90by9uUUstNl92Wk10NW44OHpzQVM5NGV3L21zLmpwZyIsDQogICAgICAgICAgICAiaXNfY2xhaW1lZCI6IHRydWUsDQogICAgICAgICAgICAiaXNfY2xvc2VkIjogZmFsc2UsDQogICAgICAgICAgICAibG9jYXRpb24iOiB7DQogICAgICAgICAgICAgICAgImFkZHJlc3MiOiBbDQogICAgICAgICAgICAgICAgICAgICIxNDAgTmV3IE1vbnRnb21lcnkgU3QiDQogICAgICAgICAgICAgICAgXSwNCiAgICAgICAgICAgICAgICAiY2l0eSI6ICJTYW4gRnJhbmNpc2NvIiwNCiAgICAgICAgICAgICAgICAiY29vcmRpbmF0ZSI6IHsNCiAgICAgICAgICAgICAgICAgICAgImxhdGl0dWRlIjogMzcuNzg2NzcwMzM2MjkyOSwNCiAgICAgICAgICAgICAgICAgICAgImxvbmdpdHVkZSI6IC0xMjIuMzk5OTU4MzcyMTE1DQogICAgICAgICAgICAgICAgfSwNCiAgICAgICAgICAgICAgICAiY291bnRyeV9jb2RlIjogIlVTIiwNCiAgICAgICAgICAgICAgICAiY3Jvc3Nfc3RyZWV0cyI6ICJOYXRvbWEgU3QgJiBNaW5uYSBTdCIsDQogICAgICAgICAgICAgICAgImRpc3BsYXlfYWRkcmVzcyI6IFsNCiAgICAgICAgICAgICAgICAgICAgIjE0MCBOZXcgTW9udGdvbWVyeSBTdCIsDQogICAgICAgICAgICAgICAgICAgICJGaW5hbmNpYWwgRGlzdHJpY3QiLA0KICAgICAgICAgICAgICAgICAgICAiU2FuIEZyYW5jaXNjbywgQ0EgOTQxMDUiDQogICAgICAgICAgICAgICAgXSwNCiAgICAgICAgICAgICAgICAiZ2VvX2FjY3VyYWN5IjogOS41LA0KICAgICAgICAgICAgICAgICJuZWlnaGJvcmhvb2RzIjogWw0KICAgICAgICAgICAgICAgICAgICAiRmluYW5jaWFsIERpc3RyaWN0IiwNCiAgICAgICAgICAgICAgICAgICAgIlNvTWEiDQogICAgICAgICAgICAgICAgXSwNCiAgICAgICAgICAgICAgICAicG9zdGFsX2NvZGUiOiAiOTQxMDUiLA0KICAgICAgICAgICAgICAgICJzdGF0ZV9jb2RlIjogIkNBIg0KICAgICAgICAgICAgfSwNCiAgICAgICAgICAgICJtb2JpbGVfdXJsIjogImh0dHA6Ly9tLnllbHAuY29tL2Jpei95ZWxwLXNhbi1mcmFuY2lzY28iLA0KICAgICAgICAgICAgIm5hbWUiOiAiWWVscCIsDQogICAgICAgICAgICAicGhvbmUiOiAiNDE1OTA4MzgwMSIsDQogICAgICAgICAgICAicmF0aW5nIjogMi41LA0KICAgICAgICAgICAgInJhdGluZ19pbWdfdXJsIjogImh0dHA6Ly9zMy1tZWRpYTQuZmwueWVscGNkbi5jb20vYXNzZXRzLzIvd3d3L2ltZy9jN2ZiOWFmZjU5ZjkvaWNvL3N0YXJzL3YxL3N0YXJzXzJfaGFsZi5wbmciLA0KICAgICAgICAgICAgInJhdGluZ19pbWdfdXJsX2xhcmdlIjogImh0dHA6Ly9zMy1tZWRpYTIuZmwueWVscGNkbi5jb20vYXNzZXRzLzIvd3d3L2ltZy9kNjNlM2FkZDk5MDEvaWNvL3N0YXJzL3YxL3N0YXJzX2xhcmdlXzJfaGFsZi5wbmciLA0KICAgICAgICAgICAgInJhdGluZ19pbWdfdXJsX3NtYWxsIjogImh0dHA6Ly9zMy1tZWRpYTQuZmwueWVscGNkbi5jb20vYXNzZXRzLzIvd3d3L2ltZy84ZTg2MzNlNWY4ZjAvaWNvL3N0YXJzL3YxL3N0YXJzX3NtYWxsXzJfaGFsZi5wbmciLA0KICAgICAgICAgICAgInJldmlld19jb3VudCI6IDcxNDAsDQogICAgICAgICAgICAic25pcHBldF9pbWFnZV91cmwiOiAiaHR0cDovL3MzLW1lZGlhNC5mbC55ZWxwY2RuLmNvbS9waG90by9ZY2pQU2N3VnhGMDVrajZ6dDEwRnh3L21zLmpwZyIsDQogICAgICAgICAgICAic25pcHBldF90ZXh0IjogIldoYXQgd291bGQgSSBkbyB3aXRob3V0IFllbHA/XG5cbkkgd291bGRuJ3QgYmUgSEFMRiB0aGUgZm9vZGllIEkndmUgYmVjb21lIGl0IHdlcmVuJ3QgZm9yIHRoaXMgYnVzaW5lc3MuICAgIFxuXG5ZZWxwIG1ha2VzIGl0IHZpcnR1YWxseSBlZmZvcnRsZXNzIHRvIGRpc2NvdmVyIG5ldy4uLiIsDQogICAgICAgICAgICAidXJsIjogImh0dHA6Ly93d3cueWVscC5jb20vYml6L3llbHAtc2FuLWZyYW5jaXNjbyINCiAgICAgICAgfQ0KICAgIF0sDQogICAgInRvdGFsIjogMjMxNg0KfQ=="
  
  static let yelpValidThreeBusinessResponse = "ew0KICAgICJyZWdpb24iOiB7DQogICAgICAgICJzcGFuIjogew0KICAgICAgICAgICAgImxhdGl0dWRlX2RlbHRhIjogMC4wMTM5NDYzNDk5OTk5OTc2NjUsIA0KICAgICAgICAgICAgImxvbmdpdHVkZV9kZWx0YSI6IDAuMDA5MDg4MzEwMDAwMDA5ODcNCiAgICAgICAgfSwgDQogICAgICAgICJjZW50ZXIiOiB7DQogICAgICAgICAgICAibGF0aXR1ZGUiOiAzNy43NTM0MjQ3NDk5OTk5OSwgDQogICAgICAgICAgICAibG9uZ2l0dWRlIjogLTEyMi40MjI5MjA5NDk5OTk5OQ0KICAgICAgICB9DQogICAgfSwgDQogICAgInRvdGFsIjogNTA1NTksIA0KICAgICJidXNpbmVzc2VzIjogWw0KICAgICAgICB7DQogICAgICAgICAgICAiaXNfY2xhaW1lZCI6IHRydWUsIA0KICAgICAgICAgICAgInJhdGluZyI6IDUuMCwgDQogICAgICAgICAgICAibW9iaWxlX3VybCI6ICJodHRwOi8vbS55ZWxwLmNvbS9iaXovdGhlLXRlbXBvcmFyaXVtLWNvZmZlZS1hbmQtdGVhLXNhbi1mcmFuY2lzY28/dXRtX2NhbXBhaWduPXllbHBfYXBpJnV0bV9tZWRpdW09YXBpX3YyX3NlYXJjaCZ1dG1fc291cmNlPU9vWEtuNjQ2TXhsOGp3SjdMVmdvdWciLCANCiAgICAgICAgICAgICJyYXRpbmdfaW1nX3VybCI6ICJodHRwczovL3MzLW1lZGlhMS5mbC55ZWxwY2RuLmNvbS9hc3NldHMvMi93d3cvaW1nL2YxZGVmMTFlNGU3OS9pY28vc3RhcnMvdjEvc3RhcnNfNS5wbmciLCANCiAgICAgICAgICAgICJyZXZpZXdfY291bnQiOiA3NiwgDQogICAgICAgICAgICAibmFtZSI6ICJUaGUgVGVtcG9yYXJpdW0gQ29mZmVlICYgVGVhIiwgDQogICAgICAgICAgICAicmF0aW5nX2ltZ191cmxfc21hbGwiOiAiaHR0cHM6Ly9zMy1tZWRpYTEuZmwueWVscGNkbi5jb20vYXNzZXRzLzIvd3d3L2ltZy9jNzYyMzIwNWQ1Y2QvaWNvL3N0YXJzL3YxL3N0YXJzX3NtYWxsXzUucG5nIiwgDQogICAgICAgICAgICAidXJsIjogImh0dHA6Ly93d3cueWVscC5jb20vYml6L3RoZS10ZW1wb3Jhcml1bS1jb2ZmZWUtYW5kLXRlYS1zYW4tZnJhbmNpc2NvP3V0bV9jYW1wYWlnbj15ZWxwX2FwaSZ1dG1fbWVkaXVtPWFwaV92Ml9zZWFyY2gmdXRtX3NvdXJjZT1Pb1hLbjY0Nk14bDhqd0o3TFZnb3VnIiwgDQogICAgICAgICAgICAiY2F0ZWdvcmllcyI6IFsNCiAgICAgICAgICAgICAgICBbDQogICAgICAgICAgICAgICAgICAgICJDb2ZmZWUgJiBUZWEiLCANCiAgICAgICAgICAgICAgICAgICAgImNvZmZlZSINCiAgICAgICAgICAgICAgICBdDQogICAgICAgICAgICBdLCANCiAgICAgICAgICAgICJwaG9uZSI6ICI0MTU1NDcwNjE2IiwgDQogICAgICAgICAgICAic25pcHBldF90ZXh0IjogIlRoZSBUZW1wb3Jhcml1bSBwYWNrcyBhIHB1bmNoIGluIGEgc21hbGwgc3BhY2UuIFRoZXkgc2VydmUgZGVsaWNpb3VzIENvbnRyYWJhbmQgY29mZmVlLiBJIGFsd2F5cyBnZXQgYSBjYXBwdWNjaW5vIChteSBnbyB0bykgYW5kIEkgaGF2ZSBuZXZlciBiZWVuIGxldCBkb3duLi4uLiIsIA0KICAgICAgICAgICAgImltYWdlX3VybCI6ICJodHRwczovL3MzLW1lZGlhMS5mbC55ZWxwY2RuLmNvbS9icGhvdG8vVG9lM1JZcEI0Z3k1MFlRUGhSWXpvUS9tcy5qcGciLCANCiAgICAgICAgICAgICJzbmlwcGV0X2ltYWdlX3VybCI6ICJodHRwOi8vczMtbWVkaWE0LmZsLnllbHBjZG4uY29tL3Bob3RvL1hYaWlSSFdzTXBrLXlJMzhKeXRFYkEvbXMuanBnIiwgDQogICAgICAgICAgICAiZGlzcGxheV9waG9uZSI6ICIrMS00MTUtNTQ3LTA2MTYiLCANCiAgICAgICAgICAgICJyYXRpbmdfaW1nX3VybF9sYXJnZSI6ICJodHRwczovL3MzLW1lZGlhMy5mbC55ZWxwY2RuLmNvbS9hc3NldHMvMi93d3cvaW1nLzIyYWZmYzRlNmMzOC9pY28vc3RhcnMvdjEvc3RhcnNfbGFyZ2VfNS5wbmciLCANCiAgICAgICAgICAgICJpZCI6ICJ0aGUtdGVtcG9yYXJpdW0tY29mZmVlLWFuZC10ZWEtc2FuLWZyYW5jaXNjbyIsIA0KICAgICAgICAgICAgImlzX2Nsb3NlZCI6IGZhbHNlLCANCiAgICAgICAgICAgICJsb2NhdGlvbiI6IHsNCiAgICAgICAgICAgICAgICAiY3Jvc3Nfc3RyZWV0cyI6ICJBbWVzIFN0ICYgR3VlcnJlcm8gU3QiLCANCiAgICAgICAgICAgICAgICAiY2l0eSI6ICJTYW4gRnJhbmNpc2NvIiwgDQogICAgICAgICAgICAgICAgImRpc3BsYXlfYWRkcmVzcyI6IFsNCiAgICAgICAgICAgICAgICAgICAgIjM0MTQgMjJuZCBTdCIsIA0KICAgICAgICAgICAgICAgICAgICAiTWlzc2lvbiIsIA0KICAgICAgICAgICAgICAgICAgICAiU2FuIEZyYW5jaXNjbywgQ0EgOTQxMTAiDQogICAgICAgICAgICAgICAgXSwgDQogICAgICAgICAgICAgICAgImdlb19hY2N1cmFjeSI6IDkuNSwgDQogICAgICAgICAgICAgICAgIm5laWdoYm9yaG9vZHMiOiBbDQogICAgICAgICAgICAgICAgICAgICJNaXNzaW9uIg0KICAgICAgICAgICAgICAgIF0sIA0KICAgICAgICAgICAgICAgICJwb3N0YWxfY29kZSI6ICI5NDExMCIsIA0KICAgICAgICAgICAgICAgICJjb3VudHJ5X2NvZGUiOiAiVVMiLCANCiAgICAgICAgICAgICAgICAiYWRkcmVzcyI6IFsNCiAgICAgICAgICAgICAgICAgICAgIjM0MTQgMjJuZCBTdCINCiAgICAgICAgICAgICAgICBdLCANCiAgICAgICAgICAgICAgICAiY29vcmRpbmF0ZSI6IHsNCiAgICAgICAgICAgICAgICAgICAgImxhdGl0dWRlIjogMzcuNzU1MjI4OTU0Mzg3NCwgDQogICAgICAgICAgICAgICAgICAgICJsb25naXR1ZGUiOiAtMTIyLjQyMzU4NzIxNzE3Mg0KICAgICAgICAgICAgICAgIH0sIA0KICAgICAgICAgICAgICAgICJzdGF0ZV9jb2RlIjogIkNBIg0KICAgICAgICAgICAgfQ0KICAgICAgICB9LCANCiAgICAgICAgew0KICAgICAgICAgICAgImlzX2NsYWltZWQiOiB0cnVlLCANCiAgICAgICAgICAgICJyYXRpbmciOiA1LjAsIA0KICAgICAgICAgICAgIm1vYmlsZV91cmwiOiAiaHR0cDovL20ueWVscC5jb20vYml6L2NvZmZlZXNob3Atc2FuLWZyYW5jaXNjbz91dG1fY2FtcGFpZ249eWVscF9hcGkmdXRtX21lZGl1bT1hcGlfdjJfc2VhcmNoJnV0bV9zb3VyY2U9T29YS242NDZNeGw4andKN0xWZ291ZyIsIA0KICAgICAgICAgICAgInJhdGluZ19pbWdfdXJsIjogImh0dHBzOi8vczMtbWVkaWExLmZsLnllbHBjZG4uY29tL2Fzc2V0cy8yL3d3dy9pbWcvZjFkZWYxMWU0ZTc5L2ljby9zdGFycy92MS9zdGFyc181LnBuZyIsIA0KICAgICAgICAgICAgInJldmlld19jb3VudCI6IDIzNywgDQogICAgICAgICAgICAibmFtZSI6ICJDb2ZmZWVTaG9wIiwgDQogICAgICAgICAgICAicmF0aW5nX2ltZ191cmxfc21hbGwiOiAiaHR0cHM6Ly9zMy1tZWRpYTEuZmwueWVscGNkbi5jb20vYXNzZXRzLzIvd3d3L2ltZy9jNzYyMzIwNWQ1Y2QvaWNvL3N0YXJzL3YxL3N0YXJzX3NtYWxsXzUucG5nIiwgDQogICAgICAgICAgICAidXJsIjogImh0dHA6Ly93d3cueWVscC5jb20vYml6L2NvZmZlZXNob3Atc2FuLWZyYW5jaXNjbz91dG1fY2FtcGFpZ249eWVscF9hcGkmdXRtX21lZGl1bT1hcGlfdjJfc2VhcmNoJnV0bV9zb3VyY2U9T29YS242NDZNeGw4andKN0xWZ291ZyIsIA0KICAgICAgICAgICAgImNhdGVnb3JpZXMiOiBbDQogICAgICAgICAgICAgICAgWw0KICAgICAgICAgICAgICAgICAgICAiQ29mZmVlICYgVGVhIiwgDQogICAgICAgICAgICAgICAgICAgICJjb2ZmZWUiDQogICAgICAgICAgICAgICAgXQ0KICAgICAgICAgICAgXSwgDQogICAgICAgICAgICAicGhvbmUiOiAiNDE1MzY4MzgwMiIsIA0KICAgICAgICAgICAgInNuaXBwZXRfdGV4dCI6ICJMb29rIGZvciB0aGUgZ3JlZW4gYnVpbGRpbmcuIFxuXG5CdWxsZXRwcm9vZiBDb2ZmZWUgZ29lcyBieSB0aGUgbmFtZSBvZiBcIlNoZXJwYVwiIGhlcmUuIEkgbWFrZSB0aGlzIGV2ZXJ5IG1vcm5pbmcgYXQgaG9tZSBhbmQgd2FzIGVjc3RhdGljIHRvIHNlZSBpdCBiZWluZy4uLiIsIA0KICAgICAgICAgICAgImltYWdlX3VybCI6ICJodHRwczovL3MzLW1lZGlhNC5mbC55ZWxwY2RuLmNvbS9icGhvdG8vRkE5YVBIU2MweTdVdFZDRFZPbXVQZy9tcy5qcGciLCANCiAgICAgICAgICAgICJzbmlwcGV0X2ltYWdlX3VybCI6ICJodHRwOi8vczMtbWVkaWExLmZsLnllbHBjZG4uY29tL3Bob3RvLzR3bEVOYzQ4b25DNDZIWUE2Ul9RTkEvbXMuanBnIiwgDQogICAgICAgICAgICAiZGlzcGxheV9waG9uZSI6ICIrMS00MTUtMzY4LTM4MDIiLCANCiAgICAgICAgICAgICJyYXRpbmdfaW1nX3VybF9sYXJnZSI6ICJodHRwczovL3MzLW1lZGlhMy5mbC55ZWxwY2RuLmNvbS9hc3NldHMvMi93d3cvaW1nLzIyYWZmYzRlNmMzOC9pY28vc3RhcnMvdjEvc3RhcnNfbGFyZ2VfNS5wbmciLCANCiAgICAgICAgICAgICJpZCI6ICJjb2ZmZWVzaG9wLXNhbi1mcmFuY2lzY28iLCANCiAgICAgICAgICAgICJpc19jbG9zZWQiOiBmYWxzZSwgDQogICAgICAgICAgICAibG9jYXRpb24iOiB7DQogICAgICAgICAgICAgICAgImNyb3NzX3N0cmVldHMiOiAiQ2FwcCBTdCAmIFByZWNpdGEgQXZlIiwgDQogICAgICAgICAgICAgICAgImNpdHkiOiAiU2FuIEZyYW5jaXNjbyIsIA0KICAgICAgICAgICAgICAgICJkaXNwbGF5X2FkZHJlc3MiOiBbDQogICAgICAgICAgICAgICAgICAgICIzMTM5IE1pc3Npb24gU3QiLCANCiAgICAgICAgICAgICAgICAgICAgIkJlcm5hbCBIZWlnaHRzIiwgDQogICAgICAgICAgICAgICAgICAgICJTYW4gRnJhbmNpc2NvLCBDQSA5NDExMCINCiAgICAgICAgICAgICAgICBdLCANCiAgICAgICAgICAgICAgICAiZ2VvX2FjY3VyYWN5IjogOS41LCANCiAgICAgICAgICAgICAgICAibmVpZ2hib3Job29kcyI6IFsNCiAgICAgICAgICAgICAgICAgICAgIkJlcm5hbCBIZWlnaHRzIiwgDQogICAgICAgICAgICAgICAgICAgICJNaXNzaW9uIg0KICAgICAgICAgICAgICAgIF0sIA0KICAgICAgICAgICAgICAgICJwb3N0YWxfY29kZSI6ICI5NDExMCIsIA0KICAgICAgICAgICAgICAgICJjb3VudHJ5X2NvZGUiOiAiVVMiLCANCiAgICAgICAgICAgICAgICAiYWRkcmVzcyI6IFsNCiAgICAgICAgICAgICAgICAgICAgIjMxMzkgTWlzc2lvbiBTdCINCiAgICAgICAgICAgICAgICBdLCANCiAgICAgICAgICAgICAgICAiY29vcmRpbmF0ZSI6IHsNCiAgICAgICAgICAgICAgICAgICAgImxhdGl0dWRlIjogMzcuNzQ3MDg1NSwgDQogICAgICAgICAgICAgICAgICAgICJsb25naXR1ZGUiOiAtMTIyLjQxODc4OTkNCiAgICAgICAgICAgICAgICB9LCANCiAgICAgICAgICAgICAgICAic3RhdGVfY29kZSI6ICJDQSINCiAgICAgICAgICAgIH0NCiAgICAgICAgfSwgDQogICAgICAgIHsNCiAgICAgICAgICAgICJpc19jbGFpbWVkIjogZmFsc2UsIA0KICAgICAgICAgICAgInJhdGluZyI6IDQuNSwgDQogICAgICAgICAgICAibW9iaWxlX3VybCI6ICJodHRwOi8vbS55ZWxwLmNvbS9iaXovZG9sb3Jlcy1wYXJrLXNhbi1mcmFuY2lzY28/dXRtX2NhbXBhaWduPXllbHBfYXBpJnV0bV9tZWRpdW09YXBpX3YyX3NlYXJjaCZ1dG1fc291cmNlPU9vWEtuNjQ2TXhsOGp3SjdMVmdvdWciLCANCiAgICAgICAgICAgICJyYXRpbmdfaW1nX3VybCI6ICJodHRwczovL3MzLW1lZGlhMi5mbC55ZWxwY2RuLmNvbS9hc3NldHMvMi93d3cvaW1nLzk5NDkzYzEyNzExZS9pY28vc3RhcnMvdjEvc3RhcnNfNF9oYWxmLnBuZyIsIA0KICAgICAgICAgICAgInJldmlld19jb3VudCI6IDEyODEsIA0KICAgICAgICAgICAgIm5hbWUiOiAiRG9sb3JlcyBQYXJrIiwgDQogICAgICAgICAgICAicmF0aW5nX2ltZ191cmxfc21hbGwiOiAiaHR0cHM6Ly9zMy1tZWRpYTIuZmwueWVscGNkbi5jb20vYXNzZXRzLzIvd3d3L2ltZy9hNTIyMWU2NmJjNzAvaWNvL3N0YXJzL3YxL3N0YXJzX3NtYWxsXzRfaGFsZi5wbmciLCANCiAgICAgICAgICAgICJ1cmwiOiAiaHR0cDovL3d3dy55ZWxwLmNvbS9iaXovZG9sb3Jlcy1wYXJrLXNhbi1mcmFuY2lzY28/dXRtX2NhbXBhaWduPXllbHBfYXBpJnV0bV9tZWRpdW09YXBpX3YyX3NlYXJjaCZ1dG1fc291cmNlPU9vWEtuNjQ2TXhsOGp3SjdMVmdvdWciLCANCiAgICAgICAgICAgICJjYXRlZ29yaWVzIjogWw0KICAgICAgICAgICAgICAgIFsNCiAgICAgICAgICAgICAgICAgICAgIlBhcmtzIiwgDQogICAgICAgICAgICAgICAgICAgICJwYXJrcyINCiAgICAgICAgICAgICAgICBdDQogICAgICAgICAgICBdLCANCiAgICAgICAgICAgICJzbmlwcGV0X3RleHQiOiAiUGVvcGxlIHdhdGNoaW5nPyBcbkNoZWNrISBQZXJoYXBzIHRoZSBiZXN0IGluIHRoZSBjaXR5XG5cbjQyMCBGcmllbmRseT8gXG5DaGVjayEgUGxlbnR5IG9mIGdhbmphcHJlbmV1cnMgdG8gcHVyY2hhc2UgZnJvbSB3aXRoaW4gc3RlcHMgYXdheSBhbmQgeW91J2xsIGZpbmQgYS4uLiIsIA0KICAgICAgICAgICAgImltYWdlX3VybCI6ICJodHRwczovL3MzLW1lZGlhMi5mbC55ZWxwY2RuLmNvbS9icGhvdG8vVGNDcWVPU01fU3Fad185VEliTUNQZy9tcy5qcGciLCANCiAgICAgICAgICAgICJzbmlwcGV0X2ltYWdlX3VybCI6ICJodHRwOi8vczMtbWVkaWExLmZsLnllbHBjZG4uY29tL3Bob3RvL056dFBPblJManBUbDVXdEFvemh0ZmcvbXMuanBnIiwgDQogICAgICAgICAgICAicmF0aW5nX2ltZ191cmxfbGFyZ2UiOiAiaHR0cHM6Ly9zMy1tZWRpYTQuZmwueWVscGNkbi5jb20vYXNzZXRzLzIvd3d3L2ltZy85ZjgzNzkwZmY3ZjYvaWNvL3N0YXJzL3YxL3N0YXJzX2xhcmdlXzRfaGFsZi5wbmciLCANCiAgICAgICAgICAgICJpZCI6ICJkb2xvcmVzLXBhcmstc2FuLWZyYW5jaXNjbyIsIA0KICAgICAgICAgICAgImlzX2Nsb3NlZCI6IGZhbHNlLCANCiAgICAgICAgICAgICJsb2NhdGlvbiI6IHsNCiAgICAgICAgICAgICAgICAiY2l0eSI6ICJTYW4gRnJhbmNpc2NvIiwgDQogICAgICAgICAgICAgICAgImRpc3BsYXlfYWRkcmVzcyI6IFsNCiAgICAgICAgICAgICAgICAgICAgIkRvbG9yZXMgU3QiLCANCiAgICAgICAgICAgICAgICAgICAgIkNhc3RybyIsIA0KICAgICAgICAgICAgICAgICAgICAiU2FuIEZyYW5jaXNjbywgQ0EgOTQxMTQiDQogICAgICAgICAgICAgICAgXSwgDQogICAgICAgICAgICAgICAgImdlb19hY2N1cmFjeSI6IDkuNSwgDQogICAgICAgICAgICAgICAgIm5laWdoYm9yaG9vZHMiOiBbDQogICAgICAgICAgICAgICAgICAgICJDYXN0cm8iDQogICAgICAgICAgICAgICAgXSwgDQogICAgICAgICAgICAgICAgInBvc3RhbF9jb2RlIjogIjk0MTE0IiwgDQogICAgICAgICAgICAgICAgImNvdW50cnlfY29kZSI6ICJVUyIsIA0KICAgICAgICAgICAgICAgICJhZGRyZXNzIjogWw0KICAgICAgICAgICAgICAgICAgICAiRG9sb3JlcyBTdCINCiAgICAgICAgICAgICAgICBdLCANCiAgICAgICAgICAgICAgICAiY29vcmRpbmF0ZSI6IHsNCiAgICAgICAgICAgICAgICAgICAgImxhdGl0dWRlIjogMzcuNzU5NzY0LCANCiAgICAgICAgICAgICAgICAgICAgImxvbmdpdHVkZSI6IC0xMjIuNDI3MDUyDQogICAgICAgICAgICAgICAgfSwgDQogICAgICAgICAgICAgICAgInN0YXRlX2NvZGUiOiAiQ0EiDQogICAgICAgICAgICB9DQogICAgICAgIH0NCiAgICBdDQp9"
  
  static let yelpValidImage = "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"
  
  static let yelpValidBusinessResponse = "ew0KICAgICJjYXRlZ29yaWVzIjogWw0KICAgICAgICBbDQogICAgICAgICAgICAiSW5kaWFuIiwNCiAgICAgICAgICAgICJpbmRwYWsiDQogICAgICAgIF0sDQogICAgICAgIFsNCiAgICAgICAgICAgICJIaW1hbGF5YW4vTmVwYWxlc2UiLA0KICAgICAgICAgICAgImhpbWFsYXlhbiINCiAgICAgICAgXQ0KICAgIF0sDQogICAgImRlYWxzIjogWw0KICAgICAgICB7DQogICAgICAgICAgICAiY3VycmVuY3lfY29kZSI6ICJVU0QiLA0KICAgICAgICAgICAgImltYWdlX3VybCI6ICJodHRwOi8vczMtbWVkaWE0LmFrLnllbHBjZG4uY29tL2RwaG90by9TaFFHZjVxaS01Mkh3UGlLeVpUWjN3L20uanBnIiwNCiAgICAgICAgICAgICJvcHRpb25zIjogWw0KICAgICAgICAgICAgICAgIHsNCiAgICAgICAgICAgICAgICAgICAgImZvcm1hdHRlZF9vcmlnaW5hbF9wcmljZSI6ICIkMjAiLA0KICAgICAgICAgICAgICAgICAgICAiZm9ybWF0dGVkX3ByaWNlIjogIiQxMCIsDQogICAgICAgICAgICAgICAgICAgICJpc19xdWFudGl0eV9saW1pdGVkIjogdHJ1ZSwNCiAgICAgICAgICAgICAgICAgICAgIm9yaWdpbmFsX3ByaWNlIjogMjAwMCwNCiAgICAgICAgICAgICAgICAgICAgInByaWNlIjogMTAwMCwNCiAgICAgICAgICAgICAgICAgICAgInB1cmNoYXNlX3VybCI6ICJodHRwOi8vd3d3LnllbHAuY29tL2RlYWwvY0MyNGNjUUdJSDhtb3dmdTVWYmUwUS92aWV3IiwNCiAgICAgICAgICAgICAgICAgICAgInJlbWFpbmluZ19jb3VudCI6IDM2LA0KICAgICAgICAgICAgICAgICAgICAidGl0bGUiOiAiJDEwIGZvciAkMjAgdm91Y2hlciINCiAgICAgICAgICAgICAgICB9DQogICAgICAgICAgICBdLA0KICAgICAgICAgICAgInVybCI6ICJodHRwOi8vd3d3LnllbHAuY29tL2Jpei91cmJhbi1jdXJyeS1zYW4tZnJhbmNpc2NvP2RlYWw9MSIsDQogICAgICAgICAgICAiaXNfcG9wdWxhciI6IHRydWUsDQogICAgICAgICAgICAidGltZV9zdGFydCI6IDEzMTc0MTQzNjksDQogICAgICAgICAgICAidGl0bGUiOiAiJDEwIGZvciAkMjAgdm91Y2hlciINCiAgICAgICAgfQ0KICAgIF0sDQogICAgImRpc3BsYXlfcGhvbmUiOiAiKzEtNDE1LTY3Ny05NzQzIiwNCiAgICAiZWF0MjRfdXJsIjogImh0dHA6Ly9lMjQuaW8vci81NzY5P3V0bV9jYW1wYWlnbj1wdWJsaWMmdXRtX21lZGl1bT15ZWxwYXBpJnV0bV9zb3VyY2U9eWVscGFwaSIsDQogICAgImdpZnRfY2VydGlmaWNhdGVzIjogWw0KICAgICAgICB7DQogICAgICAgICAgICAiY3VycmVuY3lfY29kZSI6ICJVU0QiLA0KICAgICAgICAgICAgImltYWdlX3VybCI6ICJodHRwOi8vczMtbWVkaWE0LmFrLnllbHBjZG4uY29tL2JwaG90by9IdjV2c1dwcWVhVUtlcHI5bmZmSm53L20uanBnIiwNCiAgICAgICAgICAgICJvcHRpb25zIjogWw0KICAgICAgICAgICAgICAgIHsNCiAgICAgICAgICAgICAgICAgICAgImZvcm1hdHRlZF9wcmljZSI6ICIkMjUiLA0KICAgICAgICAgICAgICAgICAgICAicHJpY2UiOiAyNTAwDQogICAgICAgICAgICAgICAgfSwNCiAgICAgICAgICAgICAgICB7DQogICAgICAgICAgICAgICAgICAgICJmb3JtYXR0ZWRfcHJpY2UiOiAiJDUwIiwNCiAgICAgICAgICAgICAgICAgICAgInByaWNlIjogNTAwMA0KICAgICAgICAgICAgICAgIH0NCiAgICAgICAgICAgIF0sDQogICAgICAgICAgICAidXJsIjogImh0dHA6Ly93d3cueWVscC5jb20vZ2lmdC1jZXJ0aWZpY2F0ZXMvc29tZS1kb251dC1wbGFjZS1wYXNhZGVuYSIsDQogICAgICAgICAgICAiaWQiOiAiWlp5NUV3ckkzd3lIdzh5NTRqWnJ1QSIsDQogICAgICAgICAgICAidW51c2VkX2JhbGFuY2VzIjogIkNSRURJVCINCiAgICAgICAgfQ0KICAgIF0sDQogICAgImlkIjogInVyYmFuLWN1cnJ5LXNhbi1mcmFuY2lzY28iLA0KICAgICJpbWFnZV91cmwiOiAiaHR0cDovL3MzLW1lZGlhMS5mbC55ZWxwY2RuLmNvbS9icGhvdG8vdTViMXU3YzA0QzFHa3B0VWcwZ3JkQS9tcy5qcGciLA0KICAgICJpc19jbGFpbWVkIjogdHJ1ZSwNCiAgICAiaXNfY2xvc2VkIjogZmFsc2UsDQogICAgImxvY2F0aW9uIjogew0KICAgICAgICAiYWRkcmVzcyI6IFsNCiAgICAgICAgICAgICI1MjMgQnJvYWR3YXkiDQogICAgICAgIF0sDQogICAgICAgICJjaXR5IjogIlNhbiBGcmFuY2lzY28iLA0KICAgICAgICAiY29vcmRpbmF0ZSI6IHsNCiAgICAgICAgICAgICJsYXRpdHVkZSI6IDM3Ljc5Nzg5OTQsDQogICAgICAgICAgICAibG9uZ2l0dWRlIjogLTEyMi40MDU5NjQ5DQogICAgICAgIH0sDQogICAgICAgICJjb3VudHJ5X2NvZGUiOiAiVVMiLA0KICAgICAgICAiY3Jvc3Nfc3RyZWV0cyI6ICJSb21vbG8gUGwgJiBLZWFybnkgU3QiLA0KICAgICAgICAiZGlzcGxheV9hZGRyZXNzIjogWw0KICAgICAgICAgICAgIjUyMyBCcm9hZHdheSIsDQogICAgICAgICAgICAiTm9ydGggQmVhY2gvVGVsZWdyYXBoIEhpbGwiLA0KICAgICAgICAgICAgIlNhbiBGcmFuY2lzY28sIENBIDk0MTMzIg0KICAgICAgICBdLA0KICAgICAgICAiZ2VvX2FjY3VyYWN5IjogOS41LA0KICAgICAgICAibmVpZ2hib3Job29kcyI6IFsNCiAgICAgICAgICAgICJOb3J0aCBCZWFjaC9UZWxlZ3JhcGggSGlsbCIsDQogICAgICAgICAgICAiQ2hpbmF0b3duIg0KICAgICAgICBdLA0KICAgICAgICAicG9zdGFsX2NvZGUiOiAiOTQxMzMiLA0KICAgICAgICAic3RhdGVfY29kZSI6ICJDQSINCiAgICB9LA0KICAgICJtZW51X2RhdGVfdXBkYXRlZCI6IDE0NDMwNDA3NTEsDQogICAgIm1lbnVfcHJvdmlkZXIiOiAic2luZ2xlX3BsYXRmb3JtIiwNCiAgICAibW9iaWxlX3VybCI6ICJodHRwOi8vbS55ZWxwLmNvbS9iaXovdXJiYW4tY3Vycnktc2FuLWZyYW5jaXNjbyIsDQogICAgIm5hbWUiOiAiVXJiYW4gQ3VycnkiLA0KICAgICJwaG9uZSI6ICI0MTU2Nzc5NzQzIiwNCiAgICAicmF0aW5nIjogNC4wLA0KICAgICJyYXRpbmdfaW1nX3VybCI6ICJodHRwOi8vczMtbWVkaWE0LmZsLnllbHBjZG4uY29tL2Fzc2V0cy8yL3d3dy9pbWcvYzJmM2RkOTc5OWE1L2ljby9zdGFycy92MS9zdGFyc180LnBuZyIsDQogICAgInJhdGluZ19pbWdfdXJsX2xhcmdlIjogImh0dHA6Ly9zMy1tZWRpYTIuZmwueWVscGNkbi5jb20vYXNzZXRzLzIvd3d3L2ltZy9jY2YyYjc2ZmFhMmMvaWNvL3N0YXJzL3YxL3N0YXJzX2xhcmdlXzQucG5nIiwNCiAgICAicmF0aW5nX2ltZ191cmxfc21hbGwiOiAiaHR0cDovL3MzLW1lZGlhNC5mbC55ZWxwY2RuLmNvbS9hc3NldHMvMi93d3cvaW1nL2Y2MmE1YmUyZjkwMi9pY28vc3RhcnMvdjEvc3RhcnNfc21hbGxfNC5wbmciLA0KICAgICJyZXZpZXdfY291bnQiOiA0NTUsDQogICAgInJldmlld3MiOiBbDQogICAgICAgIHsNCiAgICAgICAgICAgICJleGNlcnB0IjogIk9uZSBvZiB0aGUgb3duZXJzIGlzIGEgZm9ybWVyIFNoZXJwYSBmcm9tIE5lcGFsIHdobyBoYXMgc3VtbWl0dGVkIE10LiBFdmVyZXN0IHR3aWNlLiBXaGlsZSB0aGUgcmVzdGF1cmFudCBpcyBpbiBhIHNlZWRlciBwYXJ0IG9mIHRoZSBDaXR5LCBpdCdzIGFsc28gb24gb25lLi4uIiwNCiAgICAgICAgICAgICJpZCI6ICJmbEFLOE11NGF1VWRjRk5SN2lQYTZRIiwNCiAgICAgICAgICAgICJyYXRpbmciOiA0LA0KICAgICAgICAgICAgInJhdGluZ19pbWFnZV9sYXJnZV91cmwiOiAiaHR0cDovL3MzLW1lZGlhMi5mbC55ZWxwY2RuLmNvbS9hc3NldHMvMi93d3cvaW1nL2NjZjJiNzZmYWEyYy9pY28vc3RhcnMvdjEvc3RhcnNfbGFyZ2VfNC5wbmciLA0KICAgICAgICAgICAgInJhdGluZ19pbWFnZV9zbWFsbF91cmwiOiAiaHR0cDovL3MzLW1lZGlhNC5mbC55ZWxwY2RuLmNvbS9hc3NldHMvMi93d3cvaW1nL2Y2MmE1YmUyZjkwMi9pY28vc3RhcnMvdjEvc3RhcnNfc21hbGxfNC5wbmciLA0KICAgICAgICAgICAgInJhdGluZ19pbWFnZV91cmwiOiAiaHR0cDovL3MzLW1lZGlhNC5mbC55ZWxwY2RuLmNvbS9hc3NldHMvMi93d3cvaW1nL2MyZjNkZDk3OTlhNS9pY28vc3RhcnMvdjEvc3RhcnNfNC5wbmciLA0KICAgICAgICAgICAgInRpbWVfY3JlYXRlZCI6IDE0NDA4OTUyNDUsDQogICAgICAgICAgICAidXNlciI6IHsNCiAgICAgICAgICAgICAgICAiaWQiOiAiM0tOTnhzUWE0dW9vSzVGQWo3YlZhUSIsDQogICAgICAgICAgICAgICAgImltYWdlX3VybCI6ICJodHRwOi8vczMtbWVkaWEzLmZsLnllbHBjZG4uY29tL3Bob3RvL2hrMzFCa0p2SjhxY3FvVXZaMzhybVEvbXMuanBnIiwNCiAgICAgICAgICAgICAgICAibmFtZSI6ICJIaWxhcnkgQy4iDQogICAgICAgICAgICB9DQogICAgICAgIH0NCiAgICBdLA0KICAgICJzbmlwcGV0X2ltYWdlX3VybCI6ICJodHRwOi8vczMtbWVkaWEzLmZsLnllbHBjZG4uY29tL3Bob3RvL2hrMzFCa0p2SjhxY3FvVXZaMzhybVEvbXMuanBnIiwNCiAgICAic25pcHBldF90ZXh0IjogIk9uZSBvZiB0aGUgb3duZXJzIGlzIGEgZm9ybWVyIFNoZXJwYSBmcm9tIE5lcGFsIHdobyBoYXMgc3VtbWl0dGVkIE10LiBFdmVyZXN0IHR3aWNlLiBXaGlsZSB0aGUgcmVzdGF1cmFudCBpcyBpbiBhIHNlZWRlciBwYXJ0IG9mIHRoZSBDaXR5LCBpdCdzIGFsc28gb24gb25lLi4uIiwNCiAgICAidXJsIjogImh0dHA6Ly93d3cueWVscC5jb20vYml6L3VyYmFuLWN1cnJ5LXNhbi1mcmFuY2lzY28iDQp9"
  
}