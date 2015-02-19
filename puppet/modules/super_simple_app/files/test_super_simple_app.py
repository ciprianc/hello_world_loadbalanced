#!/usr/bin/env python
import unittest
import super_simple_app

class CipriansTestCase(unittest.TestCase):
    def setUp(self):
        self.app = super_simple_app.app.test_client()

    def tearDown(self):
        pass

    def test_slash(self):
        rv = self.app.get('/')
        assert 'write something' in rv.data

    def test_with_data(self):
        rv = self.app.get('/this is a test')
        assert 'this is a test' in rv.data


if __name__ == '__main__':
    unittest.main()
