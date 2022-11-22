const path    = require("path")
const webpack = require("webpack")

const mode = process.env.NODE_ENV === 'development' ? 'development' : 'production'

//extracts CSS info .css file
const MiniCssExtractPlugin = require('mini-css-extract-plugin');
// Removes exported javascript files form css-only entries
const RemoveEmptyScriptsPlugin = require('webpack-remove-empty-scripts');

module.exports = {
	//mode: "production",
	mode,
	//devtool: "source-map",
	entry: {
    ticket_mailer: [ "./app/assets/stylesheets/email/ticket_mailer.scss"],
		application: [
			"./app/javascript/application.js",
			"./app/assets/stylesheets/application.scss",
		],
		custom: "./app/assets/stylesheets/custom.scss",
	},
	module: {
		rules: [
			{
				test: require.resolve("jquery"),
				loader: "expose-loader",
				options: {
					exposes: "jquery",
				},
			},
			//Add CSS/SASS/SCSS rule with loaders
			{
				test: /\.(?:sa|sc|c)ss$/i,
				use: [MiniCssExtractPlugin.loader, 'css-loader', 'sass-loader'],
			},
			{
				test: /\.(png|jpe?g|gif|eot|woff2|woff|ttf|svg)$/i,
				use: 'file-loader',
			},
		],
	},
	resolve: {
		extensions: ['.js', '.jsx', '.scss', '.css' ],
	},
	output: {
		filename: "[name].js",
		sourceMapFilename: "[file].map",
		path: path.resolve(__dirname,'app/assets/builds')
	},
	plugins: [
		new webpack.optimize.LimitChunkCountPlugin({
			maxChunks: 1
		}),
		new RemoveEmptyScriptsPlugin(),
		new MiniCssExtractPlugin(),
		new webpack.ProvidePlugin({
			$: 'jquery',
			jQuery: 'jquery',
		}),
	],
	optimization: {
		moduleIds: 'deterministic',
	}

}
