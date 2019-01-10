/** @file aracne_options.h

	Copyright (c) 2018 Santeri Puranen.

	This program is free software: you can redistribute it and/or modify
	it under the terms of the GNU Affero General Public License as
	published by the Free Software Foundation, either version 3 of the
	License, or (at your option) any later version.

	This program is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
	GNU Affero General Public License for more details.

	You should have received a copy of the GNU Affero General Public License
	along with this program. If not, see <http://www.gnu.org/licenses/>.

	@author Santeri Puranen
	$Id: $
*/

#ifndef ARACNE_OPTIONS_H
#define ARACNE_OPTIONS_H

#include <iosfwd>

// Boost includes
#include <boost/program_options.hpp>

namespace po = boost::program_options;

namespace aracne {

class ARACNE_options
{
public:
	ARACNE_options();
	ARACNE_options( std::ostream *out, std::ostream *err=nullptr );
	~ARACNE_options();

	void AddOptions( po::options_description *opdesc );
	static bool CheckOptions( po::variables_map *varmap );

	bool has_edgelist_filenames() const;
	const std::vector< std::string >& get_edgelist_filenames() const;

	const std::string& get_outfilename();

	static double get_edge_threshold();
	static void set_edge_threshold( double threshold );

	static void set_out_stream( std::ostream* out );
	static void set_err_stream( std::ostream* err );
	//> Set an ostream. An invalid ostream* (as in "out->good() == false"), will reset internal ostream ("ostream* == null_ptr").
	static std::ostream* get_out_stream();
	static std::ostream* get_err_stream();

	static const std::string& s_get_copyright_notice_string();
	static const std::string& s_get_usage_string();
	static const std::string& s_get_version_string();
	static const std::string& s_get_title_string();

	static const std::string& s_get_options_string();
	void m_set_options_string( const std::string& options_string );

	//> Test if textual output is desired. If true, then a call to get_out_stream() is guaranteed to return a valid (as in != null_ptr) ostream*.
	static bool verbose();

	static int threads();

private:
	static bool s_verbose;
	static std::ostream *s_out;
	static std::ostream *s_err;

	static int s_threads;

	std::vector< std::string > m_edgelist_filenames;
	std::string m_output_filename;
	static double s_edge_threshold;

	static const std::string s_title_string;
	static const std::string s_usage_string;
	static const std::string s_version_string;
	static const std::string s_copyright_notice;
	static const std::string s_long_copyright_notice;
	static std::string s_options_string;
	void m_init();

	static void s_init_verbose( const bool& verbose );
	static void s_init_threads( const int& nthreads );

	po::options_description
		m_general_options/*("aracne general options")*/,
		m_parallel_options/*("aracne parallel options")*/
	;

};

} // namespace aracne

#endif // ARACNE_OPTIONS_H