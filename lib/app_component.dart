// Copyright (c) 2017, Alex. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:angular2/core.dart';
import 'package:angular2_components/angular2_components.dart';

import 'checkers/checkers.dart';
import 'checkers/checkers_html_render.dart';


@Component(
	selector: 'my-app',
	styleUrls: const ['app_component.css'],
	templateUrl: 'app_component.html',
	directives: const [materialDirectives, CheckersHtml],
	providers: const [materialProviders],
)
class AppComponent {
	CheckersBoard checkersboard = new CheckersBoard();
}
