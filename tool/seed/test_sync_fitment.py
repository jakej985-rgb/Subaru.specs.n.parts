import unittest
import sys
import os
from pathlib import Path

# Add current dir to path to import the script
sys.path.append(os.path.dirname(os.path.abspath(__file__)))

import sync_fitment_csv_to_specs_json as sync_script

class TestSyncFitment(unittest.TestCase):
    
    def test_clean_row(self):
        row = {
            "year": " 2024 ",
            "qty": " 2 ",
            "serviceable": " true ",
            "notes": "  some notes  ",
            "missing": ""
        }
        cleaned = sync_script.clean_row(row)
        self.assertEqual(cleaned["year"], 2024)
        self.assertEqual(cleaned["qty"], 2)
        self.assertTrue(cleaned["serviceable"])
        self.assertEqual(cleaned["notes"], "some notes")
        self.assertEqual(cleaned["missing"], "n/a")
        
    def test_clean_row_defaults(self):
        row = {
            "year": "invalid",
            "qty": "NaN",
            "serviceable": "invalid",
        }
        cleaned = sync_script.clean_row(row)
        self.assertEqual(cleaned["year"], 0)
        self.assertEqual(cleaned["qty"], "n/a")
        self.assertEqual(cleaned["serviceable"], "n/a")

    def test_complete_bulbs(self):
        # Mock rows
        rows = [
            {
                "year": 2024, "make": "Subaru", "model": "Test", "trim": "Base", "body": "SUV", "market": "USDM",
                "function_key": "headlight_low", "location_hint": "Housing",
                "tech": "led", "serviceable": False
            }
        ]
        
        # Mock vehicles
        vehicles = [
            {"year": 2024, "make": "Subaru", "model": "Test", "trim": "Base", "body": "SUV", "market": "USDM"}
        ]
        
        # Run completion
        completed = sync_script.complete_bulbs(rows, vehicles)
        
        # Should have added required bulbs (exterior + interior)
        # Total required is len(REQUIRED_BULBS_EXTERIOR) + len(REQUIRED_BULBS_INTERIOR)
        # We provided 1 (headlight_low), so we expect the rest to be added.
        
        total_expected = len(sync_script.REQUIRED_BULBS_EXTERIOR) + len(sync_script.REQUIRED_BULBS_INTERIOR)
        
        # We need to deduplicate by function_key to count unique functions
        covered_funcs = set()
        for r in completed:
            covered_funcs.add(r["function_key"])
            
        # Check if all required functions are covered
        for req in sync_script.REQUIRED_BULBS_EXTERIOR:
            self.assertIn(req, covered_funcs)
        for req in sync_script.REQUIRED_BULBS_INTERIOR:
            self.assertIn(req, covered_funcs)
            
        # Verify placeholders structure
        for r in completed:
            if r["function_key"] == "map": # Was not provided
                self.assertEqual(r["confidence"], "n/a")
                self.assertTrue(r["serviceable"])
                self.assertEqual(r["location_hint"], "Front Overhead Console") # Default

    def test_sort_rows(self):
        rows = [
            {"year": 2022, "make": "B"},
            {"year": 2021, "make": "A"},
            {"year": 2022, "make": "A"},
        ]
        sorted_rows = sync_script.sort_rows(rows)
        self.assertEqual(sorted_rows[0]["year"], 2021)
        self.assertEqual(sorted_rows[1]["year"], 2022)
        self.assertEqual(sorted_rows[1]["make"], "A")
        self.assertEqual(sorted_rows[2]["year"], 2022)
        self.assertEqual(sorted_rows[2]["make"], "B")

if __name__ == '__main__':
    unittest.main()
