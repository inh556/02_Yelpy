# Project 2 - *Yelpy*

**Yelpy** is a Yelp search app using the [Yelp API](http://www.yelp.com/developers/documentation/v2/search_api).

Time spent: **30.5** hours spent in total

## User Stories

The following **required** functionality is completed:

- [x] Search results page
- [x] Table rows should be dynamic height according to the content height.
- [x] Custom cells should have the proper Auto Layout constraints.
- [x] Search bar should be in the navigation bar (doesn't have to expand to show location like the real Yelp app does).
- [x] Filter page. Unfortunately, not all the filters are supported in the Yelp API.
- [x] The filters you should actually have are: category, sort (best match, distance, highest rated), distance, deals (on/off).
- [x] The filters table should be organized into sections as in the mock.
- [x] You can use the default UISwitch for on/off states.
- [x] Clicking on the "Search" button should dismiss the filters page and trigger the search w/ the new filter settings.

The following **optional** features are implemented:

- [ ] Search results page
- [x] Infinite scroll for restaurant results.
- [x] Implement map view of restaurant results.
- [ ] Filter page -- **Yingying: not sure how it would different from Filter page above?**
- [ ] Implement a custom switch instead of the default UISwitch.
- [ ] Distance filter should expand as in the real Yelp app
- [ ] Categories should show a subset of the full list with a "See All" row to expand. Category list is [here](http://www.yelp.com/developers/documentation/category_list).
- [x] Implement the restaurant detail page.

The following **additional** features are implemented:

- [x] Click pin to go to details page
- [x] A map view on details page

Please list two areas of the assignment you'd like to **discuss further with your peers** during the next class (examples include better ways to implement something, how to extend your app in certain ways, etc):

1. I think it's easier to have 4 cells on the filter page, so that different section can have different looks'
2. The data passing from pins on map view to details view is tricky, spent some time to figure out how to know which pin clicked. I used a class and global var to save current pin (which is related to a business), hope there's a better & easier way.'

## Video Walkthrough

Here's a walkthrough of implemented user stories:

<img src='https://raw.githubusercontent.com/yzhanghearsay/02_Yelpy/master/ios_yelp_swift/yelpy.gif' title='Video Walkthrough' width='' alt='Video Walkthrough' />

GIF created with [LiceCap](http://www.cockos.com/licecap/).

## Notes

Describe any challenges encountered while building the app.

1. I spent so much time on figuring out the filters. Mostly working but not ideal. Once you select filter and if you go back to filter again, your previous selection was lost. I haven't figured out how to store the value.'
2. I think if there's more data for each restaurant, I can do a better details page.'
3. Used a few images from the Noun Project and <a href = "https://www.google.com/search?as_st=y&hl=en&tbs=sur%3Af&tbm=isch&sa=1&q=restaurant&oq=restaurant&gs_l=psy-ab.3..0i67k1l4.23045.23045.0.23409.1.1.0.0.0.0.119.119.0j1.1.0....0...1.1.64.psy-ab..0.1.118....0.HKeeqWVwHRU#imgrc=anN0O9s2ykwOMM:" target = "_blank">a restaurant image from Google</a>.

## License

Copyright [2017] [Yingying Zhang]

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
