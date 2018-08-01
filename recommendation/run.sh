DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo $DIR
cd $DIR

echo "Running python generator ..."
python recommendation_generator.py

echo "Running java find similarities ..."
make run
