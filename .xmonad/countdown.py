#!/usr/bin/env python2
"""Script to display a countdown until various things."""

import datetime
import pytz
import time

TARGETS = [
    (
        'Suprised Becky in Oxford',
        pytz.timezone('Europe/London').localize(
            datetime.datetime(2016, 10, 15, 9, 30),
            is_dst=False
        )
    ),
    (
        'Started talking to Becky',
        pytz.timezone('Europe/London').localize(
            datetime.datetime(2016, 6, 20, 9),
            is_dst=True
        )
    ),
    (
        'First kiss',
        pytz.timezone('Europe/London').localize(
            datetime.datetime(2016, 8, 20, 16),
            is_dst=True
        )
    ),
    (
        'Visiting Becky for Birthday',
        pytz.timezone('Europe/London').localize(
            datetime.datetime(2018, 2, 17, 12, 00),
            is_dst=False
        )
    ),
    (
        'Hamilton',
        pytz.timezone('Europe/London').localize(
            datetime.datetime(2018, 3, 19, 19, 30),
            is_dst=False
        )
    ),
    (
        'Toulouse',
        pytz.timezone('Europe/London').localize(
            datetime.datetime(2018, 3, 30, 22, 25),
            is_dst=False
        )
    ),
    (
        'Lake Como',
        pytz.timezone('Europe/Rome').localize(
            datetime.datetime(2018, 9, 04, 12, 05),
            is_dst=False
        )
    ),
]

def format_timedelta(delta):
    """Format a timedelta into a human readable format."""
    weeks, days = divmod(delta.days, 7)

    minutes, seconds = divmod(delta.seconds, 60)

    hours, minutes = divmod(minutes, 60)

    components = []

    if weeks:
        components.append(
            "{0} week{1}".format(
                weeks,
                "s" if weeks > 1 else ""
            )
        )

    if days:
        components.append(
            "{0} day{1}".format(
                days,
                "s" if days > 1 else ""
            )
        )

    if hours:
        components.append(
            "{0} hour{1}".format(
                hours,
                "s" if hours > 1 else ""
            )
        )

    if minutes:
        components.append(
            "{0} minute{1}".format(
                minutes,
                "s" if minutes > 1 else ""
            )
        )

    if seconds:
        components.append(
            "{0} second{1}".format(
                seconds,
                "s" if seconds > 1 else ""
            )
        )


    if not components:
        return "no time at all"
    elif len(components) == 1:
        return components[0]
    else:
        return "{0} and {1}".format(
            ", ".join(components[:-1]),
            components[-1]
        )

def main():
    """Calculate the time delta and format it."""
    target = TARGETS[
        int(time.time() / 5) % len(TARGETS)
    ]

    if target[1] > pytz.UTC.localize(datetime.datetime.utcnow()):
        print '{0}: {1} to go'.format(
            target[0],
            format_timedelta(
                target[1] - pytz.UTC.localize(datetime.datetime.utcnow())
            )
        )
    else:
        print '{0}: {1} ago'.format(
            target[0],
            format_timedelta(
                pytz.UTC.localize(datetime.datetime.utcnow()) - target[1]
            )
        )

if __name__ == '__main__':
    main()
